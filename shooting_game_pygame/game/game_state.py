import pygame
import random
from .constants import *
from .player import Player
from .enemy_manager import EnemyManager
from .enemy_shot import EnemyShotManager
from .resource_loader import ResourceLoader
from .effects import ParticleSystem
from .input import InputManager
from .background import Background
from .score_manager import ScoreManager

class GameState:
    def __init__(self):
        # Initialize resource loader
        self.resource_loader = ResourceLoader()
        self.resource_loader.load_images()
        self.resource_loader.load_sounds()
        self.resource_loader.load_enemy_data()
        self.resource_loader.load_event_data()
        
        # Initialize game objects
        self.player = Player(self.resource_loader)
        self.enemy_manager = EnemyManager(self.resource_loader)
        self.enemy_shot_manager = EnemyShotManager()
        self.background = Background()
        
        # Sprite groups
        self.bullets = pygame.sprite.Group()
        self.all_sprites = pygame.sprite.Group()
        self.all_sprites.add(self.player)
        
        # Particle system for explosions and effects
        self.particle_system = ParticleSystem(self.resource_loader)
        
        # Scoring system
        self.score_manager = ScoreManager()
        self.score = 0
        self.combo = 0
        self.combo_timer = 0
        
        # Start background music
        try:
            pygame.mixer.music.play(-1)  # -1 means loop indefinitely
        except pygame.error:
            print("Could not play background music")

    def handle_event(self, event):
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                self.player.shoot(self.bullets, self.all_sprites)
                self.resource_loader.sound_manager.play_sound('explosion')

    def update(self):
        # Get 8-direction input using VB6-style stick function
        stick_value = InputManager.get_stick()
        self.player.handle_input(stick_value)
        self.player.update()
        
        # Update game elements
        self.background.update()
        
        # Update enemies and handle enemy shots
        shooting_enemies = self.enemy_manager.update()
        for enemy in shooting_enemies:
            self.enemy_shot_manager.create_shot(
                enemy.float_x, enemy.float_y,
                self.player.rect.centerx, self.player.rect.centery
            )
        
        # Update shots and other elements
        self.enemy_shot_manager.update()
        self.bullets.update()
        self.particle_system.update()
        
        # Check collisions with enemy shots
        if not self.player.invulnerable:
            enemy_shots = pygame.sprite.spritecollide(
                self.player, 
                self.enemy_shot_manager.get_shots(), 
                True  # Remove shots that hit
            )
            if enemy_shots:
                self.player.hit()  # Handle player getting hit
                self.particle_system.create_explosion(
                    self.player.rect.centerx,
                    self.player.rect.centery
                )
                self.resource_loader.sound_manager.play_sound('hit')
        
        # Update combo system
        if self.combo_timer > 0:
            self.combo_timer -= 1
            if self.combo_timer <= 0:
                self.combo = 0
        
        # Check bullet collisions with enemies
        for bullet in self.bullets:
            enemies_hit = pygame.sprite.spritecollide(bullet, self.enemy_manager.get_enemies(), True)
            if enemies_hit:
                bullet.kill()
                for enemy in enemies_hit:
                    enemy.start_explosion()  # Start VB6-style explosion animation
                    # Create particle effect for additional visual feedback
                    self.particle_system.create_explosion(enemy.rect.centerx, enemy.rect.centery)
                    # Update score with combo multiplier
                    self.combo += 1
                    self.combo_timer = 120  # 2 seconds to maintain combo
                    points = len(enemies_hit) * 100 * max(1, self.combo // 2)
                    self.score += points
                    if self.score_manager.update_score(self.score):
                        # Play high score sound if available
                        self.resource_loader.sound_manager.play_sound('explosion')  # Use explosion sound for high score
        
        # Check player collision with enemies (only if not invulnerable)
        if not self.player.invulnerable and \
           pygame.sprite.spritecollide(self.player, self.enemy_manager.get_enemies(), False):
            self.game_over()

    def draw(self, screen):
        # Draw background first
        self.background.draw(screen)
        
        # Draw game objects
        self.all_sprites.draw(screen)
        self.enemy_manager.draw(screen)
        self.enemy_shot_manager.draw(screen)
        self.particle_system.draw(screen)
        
        # Draw shield effect if player is invulnerable
        if self.player.invulnerable:
            screen.blit(self.player.shield_surface, 
                       (self.player.rect.centerx - 20, 
                        self.player.rect.centery - 20))
        
        # Draw scores (matching VB6 format)
        font = pygame.font.Font(None, 20)  # Adjusted for new scale
        score_text = font.render(f'HI {self.score_manager.get_high_score():06d} SC {self.score:06d}', True, WHITE)
        screen.blit(score_text, (5, 2))
        
        if self.combo > 1:
            # Use same small font for combo display
            combo_text = font.render(f'x{self.combo}', True, (255, 165, 0))  # Shortened text
            screen.blit(combo_text, (8, 26))  # Moved closer to score display

    def game_over(self):
        # Create a large explosion effect
        self.particle_system.create_explosion(
            self.player.rect.centerx,
            self.player.rect.centery
        )
