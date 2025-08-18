import pygame
import math
import random
from .constants import *
from .sprite_manager import SpriteManager

class EnemyShot(pygame.sprite.Sprite):
    def __init__(self, x: float, y: float, target_x: float, target_y: float):
        super().__init__()
        # Create enemy shot sprite
        shot_width = int(8 * SCALE_FACTOR)
        shot_height = int(16 * SCALE_FACTOR)
        self.image = SpriteManager.create_bullet(shot_width, shot_height, RED)
        self.rect = self.image.get_rect()
        
        # Store position as float for precise movement
        self.float_x = float(x)
        self.float_y = float(y)
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Calculate movement vector (from VB6 EnemyShotRoutine)
        shot_speed = random.uniform(4, 6)  # VB6: RS = Int((6 - 4 + 1) * Rnd + 4)
        
        # Add some randomness to target position (from VB6)
        target_x += random.randint(-30, 30)
        target_y += random.randint(-30, 30)
        
        # Calculate movement direction
        dx = target_x - self.float_x
        dy = target_y - self.float_y
        distance = math.sqrt(dx * dx + dy * dy)
        
        # Set movement speed components
        if distance > 0:
            self.move_x = shot_speed * dx / distance
            self.move_y = shot_speed * dy / distance
        else:
            self.move_x = 0
            self.move_y = shot_speed

    def update(self):
        # Update position
        self.float_x += self.move_x
        self.float_y += self.move_y
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Check if shot is off screen
        if (self.rect.bottom < 0 or 
            self.rect.top > SCREEN_HEIGHT or 
            self.rect.right < 0 or 
            self.rect.left > SCREEN_WIDTH):
            self.kill()

class EnemyShotManager:
    def __init__(self):
        self.shots = pygame.sprite.Group()
        
    def create_shot(self, enemy_x: float, enemy_y: float, target_x: float, target_y: float):
        """Create a new enemy shot aimed at the target position"""
        if len(self.shots) < MAX_ENEMY_SHOTS:
            shot = EnemyShot(
                x=enemy_x + PLAYER_WIDTH/2,  # Center of enemy
                y=enemy_y + PLAYER_HEIGHT,   # Bottom of enemy
                target_x=target_x,
                target_y=target_y
            )
            self.shots.add(shot)
    
    def update(self):
        """Update all enemy shots"""
        self.shots.update()
    
    def draw(self, screen):
        """Draw all enemy shots"""
        self.shots.draw(screen)
    
    def get_shots(self):
        """Get the sprite group containing all shots"""
        return self.shots
