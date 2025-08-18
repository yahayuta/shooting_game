import pygame
import math
from .constants import *
from .sprite_manager import SpriteManager

class Player(pygame.sprite.Sprite):
    def __init__(self, resource_loader):
        super().__init__()
        # Store resource loader for sprite access
        self.resource_loader = resource_loader
        
        # Get the player sprite and mask for collision
        self.image = self.resource_loader.sprites['player_0']
        self.mask = self.resource_loader.sprite_masks.get('player_0')
        
        if not self.image:
            # Create placeholder if sprite loading failed
            self.image = pygame.Surface(
                (int(PLAYER_WIDTH * SCALE_FACTOR), 
                 int(PLAYER_HEIGHT * SCALE_FACTOR)),
                pygame.SRCALPHA
            )
            self.image.fill((255, 255, 255, 255))
        
        # Position the player
        self.rect = self.image.get_rect()
        scaled_margin = int(10 * SCALE_FACTOR)
        self.rect.centerx = SCREEN_WIDTH // 2
        self.rect.bottom = SCREEN_HEIGHT - scaled_margin
        
        # Store normal alpha for hit effect
        self.normal_alpha = 255
        
        # Movement speed (scaled)
        self.speed = int(5 * SCALE_FACTOR)
        
        # Power-up states
        self.invulnerable = False
        self.invulnerable_timer = 0
        self.spread_shot = False
        self.spread_timer = 0
        self.rapid_fire = False
        self.rapid_timer = 0
        self.shot_cooldown = 0
        self.base_cooldown = 15  # Normal fire rate (frames)
        
        # Shield effect
        self.shield_surface = pygame.Surface((40, 40), pygame.SRCALPHA)
        pygame.draw.circle(self.shield_surface, (0, 255, 255, 128), (20, 20), 20, 2)

    def handle_input(self, stick_value):
        if not self.invulnerable:
            if stick_value == 1:  # Up
                self.rect.y -= self.speed
                if self.rect.top <= 0:
                    self.rect.top = 0
            elif stick_value == 2:  # Up-Right
                self.rect.x += self.speed
                self.rect.y -= self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
                if self.rect.top <= 0:
                    self.rect.top = 0
            elif stick_value == 3:  # Right
                self.rect.x += self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
            elif stick_value == 4:  # Down-Right
                self.rect.x += self.speed
                self.rect.y += self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 5:  # Down
                self.rect.y += self.speed
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 6:  # Down-Left
                self.rect.x -= self.speed
                self.rect.y += self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 7:  # Left
                self.rect.x -= self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
            elif stick_value == 8:  # Up-Left
                self.rect.x -= self.speed
                self.rect.y -= self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
                if self.rect.top <= 0:
                    self.rect.top = 0

    def shoot(self, bullets_group, all_sprites):
        if self.shot_cooldown > 0:
            return

        if self.spread_shot:
            angles = [-30, 0, 30] if self.spread_shot else [0]
            for angle in angles:
                bullet = Bullet(self.rect.centerx, self.rect.top, angle)
                bullets_group.add(bullet)
                all_sprites.add(bullet)
        else:
            bullet = Bullet(self.rect.centerx, self.rect.top, 0)
            bullets_group.add(bullet)
            all_sprites.add(bullet)

        self.shot_cooldown = self.base_cooldown // (2 if self.rapid_fire else 1)

    def apply_powerup(self, powerup_type):
        if powerup_type == 'spread':
            self.spread_shot = True
            self.spread_timer = 600  # 10 seconds at 60 FPS
        elif powerup_type == 'speed':
            self.rapid_fire = True
            self.rapid_timer = 480  # 8 seconds at 60 FPS
        elif powerup_type == 'shield':
            self.invulnerable = True
            self.invulnerable_timer = 0

    def hit(self):
        """Called when the player is hit by an enemy or bullet"""
        if not self.invulnerable:
            self.invulnerable = True
            self.invulnerable_timer = 0
            # Visual feedback for being hit
            import pygame
import math
from .constants import *
from .sprite_manager import SpriteManager

class Player(pygame.sprite.Sprite):
    def __init__(self, resource_loader):
        super().__init__()
        # Store resource loader for sprite access
        self.resource_loader = resource_loader
        
        # Get the player sprite and mask for collision
        self.image = self.resource_loader.sprites['player_0']
        self.mask = self.resource_loader.sprite_masks.get('player_0')
        
        if not self.image:
            # Create placeholder if sprite loading failed
            self.image = pygame.Surface(
                (int(PLAYER_WIDTH * SCALE_FACTOR), 
                 int(PLAYER_HEIGHT * SCALE_FACTOR)),
                pygame.SRCALPHA
            )
            self.image.fill((255, 255, 255, 255))
        
        # Position the player
        self.rect = self.image.get_rect()
        scaled_margin = int(10 * SCALE_FACTOR)
        self.rect.centerx = SCREEN_WIDTH // 2
        self.rect.bottom = SCREEN_HEIGHT - scaled_margin
        
        # Store normal alpha for hit effect
        self.normal_alpha = 255
        
        # Movement speed (scaled)
        self.speed = int(5 * SCALE_FACTOR)
        
        # Power-up states
        self.invulnerable = False
        self.invulnerable_timer = 0
        self.shot_cooldown = 0
        self.base_cooldown = 15  # Normal fire rate (frames)
        
        # Shield effect
        self.shield_surface = pygame.Surface((40, 40), pygame.SRCALPHA)
        pygame.draw.circle(self.shield_surface, (0, 255, 255, 128), (20, 20), 20, 2)

    def handle_input(self, stick_value):
        if not self.invulnerable:
            if stick_value == 1:  # Up
                self.rect.y -= self.speed
                if self.rect.top <= 0:
                    self.rect.top = 0
            elif stick_value == 2:  # Up-Right
                self.rect.x += self.speed
                self.rect.y -= self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
                if self.rect.top <= 0:
                    self.rect.top = 0
            elif stick_value == 3:  # Right
                self.rect.x += self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
            elif stick_value == 4:  # Down-Right
                self.rect.x += self.speed
                self.rect.y += self.speed
                if self.rect.right >= SCREEN_WIDTH:
                    self.rect.right = SCREEN_WIDTH
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 5:  # Down
                self.rect.y += self.speed
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 6:  # Down-Left
                self.rect.x -= self.speed
                self.rect.y += self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
                if self.rect.bottom >= SCREEN_HEIGHT:
                    self.rect.bottom = SCREEN_HEIGHT
            elif stick_value == 7:  # Left
                self.rect.x -= self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
            elif stick_value == 8:  # Up-Left
                self.rect.x -= self.speed
                self.rect.y -= self.speed
                if self.rect.left <= 0:
                    self.rect.left = 0
                if self.rect.top <= 0:
                    self.rect.top = 0

    def shoot(self, bullets_group, all_sprites):
        if self.shot_cooldown > 0:
            return

        bullet = Bullet(self.rect.centerx, self.rect.top, 0)
        bullets_group.add(bullet)
        all_sprites.add(bullet)

        self.shot_cooldown = self.base_cooldown

    def hit(self):
        """Called when the player is hit by an enemy or bullet"""
        if not self.invulnerable:
            self.invulnerable = True
            self.invulnerable_timer = 0
            # Visual feedback for being hit
            self.image.set_alpha(128)

    def update(self):
        # Update shot cooldown
        if self.shot_cooldown > 0:
            self.shot_cooldown -= 1

        if self.invulnerable:
            self.invulnerable_timer += 1
            if self.invulnerable_timer > 300:  # 5 seconds at 60 FPS
                self.invulnerable = False
                self.invulnerable_timer = 0
            # Make the player flash when invulnerable
            if self.invulnerable_timer % 4 < 2:
                self.normal_alpha = 128
            else:
                self.normal_alpha = 255
            self.image.set_alpha(self.normal_alpha)

class Bullet(pygame.sprite.Sprite):
    def __init__(self, x, y, angle=0):
        super().__init__()
        self.image = pygame.Surface([4, 10])
        self.image.fill(WHITE)
        if angle != 0:
            self.image = pygame.transform.rotate(self.image, angle)
        self.rect = self.image.get_rect()
        self.rect.centerx = x
        self.rect.bottom = y
        
        # Convert angle to radians and store velocity components
        rad_angle = math.radians(angle)
        self.vx = -BULLET_SPEED * math.sin(rad_angle)
        self.vy = -BULLET_SPEED * math.cos(rad_angle)
        
        # Store position as floats for precise movement
        self.float_x = float(x)
        self.float_y = float(y)

    def update(self):
        # Update position using floating point values
        self.float_x += self.vx
        self.float_y += self.vy
        
        # Update rect position
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Kill if out of screen
        if self.rect.bottom < 0 or self.rect.right < 0 or self.rect.left > SCREEN_WIDTH:
            self.kill()


    def update(self):
        # Update shot cooldown
        if self.shot_cooldown > 0:
            self.shot_cooldown -= 1

        # Update power-up timers
        if self.spread_shot:
            self.spread_timer -= 1
            if self.spread_timer <= 0:
                self.spread_shot = False

        if self.rapid_fire:
            self.rapid_timer -= 1
            if self.rapid_timer <= 0:
                self.rapid_fire = False

        if self.invulnerable:
            self.invulnerable_timer += 1
            if self.invulnerable_timer > 300:  # 5 seconds at 60 FPS
                self.invulnerable = False
                self.invulnerable_timer = 0
            # Make the player flash when invulnerable
            if self.invulnerable_timer % 4 < 2:
                self.normal_alpha = 128
            else:
                self.normal_alpha = 255
            self.image.set_alpha(self.normal_alpha)

class Bullet(pygame.sprite.Sprite):
    def __init__(self, x, y, angle=0):
        super().__init__()
        self.image = pygame.Surface([4, 10])
        self.image.fill(WHITE)
        if angle != 0:
            self.image = pygame.transform.rotate(self.image, angle)
        self.rect = self.image.get_rect()
        self.rect.centerx = x
        self.rect.bottom = y
        
        # Convert angle to radians and store velocity components
        rad_angle = math.radians(angle)
        self.vx = -BULLET_SPEED * math.sin(rad_angle)
        self.vy = -BULLET_SPEED * math.cos(rad_angle)
        
        # Store position as floats for precise movement
        self.float_x = float(x)
        self.float_y = float(y)

    def update(self):
        # Update position using floating point values
        self.float_x += self.vx
        self.float_y += self.vy
        
        # Update rect position
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Kill if out of screen
        if self.rect.bottom < 0 or self.rect.right < 0 or self.rect.left > SCREEN_WIDTH:
            self.kill()
