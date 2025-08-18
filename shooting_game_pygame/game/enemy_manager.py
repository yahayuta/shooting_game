import os
import pygame
import random
import math
from typing import Optional, List
from .constants import *
from .data_loader import DataLoader, EnemyMoveData, EnemyHappenData
from .sprite_manager import SpriteManager

class Enemy(pygame.sprite.Sprite):
    def __init__(self, x: float, y: float, pattern_id: int, power: int, move_data: list[EnemyMoveData], sprite, resource_loader):
        super().__init__()
        # Store basic properties
        self.pattern_id = pattern_id
        self.power = power
        self.move_data = move_data
        self.move_index = 0
        self.move_flag = [0, 0, 0]  # VB6: MoveFlag(0 To 2)
        
        # Set up sprite and mask
        self.sprite_key = f'enemy_{pattern_id % 8}'
        self.image = sprite[0] if isinstance(sprite, tuple) else sprite  # Handle sprite+mask tuples
        self.mask = sprite[1] if isinstance(sprite, tuple) else None  # Get mask from tuple
        self.rect = self.image.get_rect()
        
        # Apply scale factor to initial position
        self.float_x = float(x) * SCALE_FACTOR
        self.float_y = float(y) * SCALE_FACTOR
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Explosion properties
        self.bom_counter = 0
        self.bom_frame_counter = 0  # For timing explosion animation
        self.active = True
        self.exploding = False  # True when enemy is in explosion animation
        self.explosion_frames = []  # Will store explosion animation frames
        self.resource_loader = resource_loader  # Store for explosion frames
        
        # Load explosion frames
        for i in range(4):  # 4 explosion frames in VB6
            frame = self.resource_loader.sprites.get(f'explosion_{i}')
            if frame:
                self.explosion_frames.append(frame)
        
    def _update_mask(self):
        """Update the sprite's collision mask"""
        if self.mask is None and hasattr(self.image, 'get_masks'):
            self.mask = pygame.mask.from_surface(self.image)

    def _reload_explosion_frames(self):
        """Reload explosion frames from resource loader"""
        self.explosion_frames = []
        for i in range(4):  # 4 explosion frames in VB6
            frame = self.resource_loader.sprites.get(f'explosion_{i}')
            if frame:
                self.explosion_frames.append(frame)

    def update(self):
        if not self.active:
            return False

        if self.exploding:
            # Update explosion animation (VB6 timing)
            self.bom_frame_counter += 1
            if self.bom_frame_counter >= 4:  # Slower timing to match VB6
                self.bom_frame_counter = 0
                self.bom_counter += 1
                if self.bom_counter >= len(self.explosion_frames):
                    self.kill()
                else:
                    self.image = self.explosion_frames[self.bom_counter]
                    # Move downward during explosion (like VB6)
                    self.float_y += 2  # Slower downward movement
                    self.rect.y = int(self.float_y)
            return False

        if self.move_index >= len(self.move_data):
            self.kill()
            return False

        current_move = self.move_data[self.move_index]
        
        # Handle special flags
        if current_move.flag >= 1 and current_move.flag <= 10:
            # Enemy should shoot
            return True  # Signal to manager to create shot
        elif current_move.flag == 253:  # Jump to specified index
            self.move_index = int(current_move.x)
            return False
        elif current_move.flag == 254:  # Loop pattern
            if self.move_flag[1] == 0:
                self.move_flag[2] = int(current_move.y)
                self.move_flag[1] = 1
            
            if self.move_flag[2] <= 0:
                self.move_flag[1] = 0
            else:
                self.move_index = int(current_move.x)
                self.move_flag[2] -= 1
            return False
        elif current_move.flag == 255:  # End of pattern
            self.kill()
            return False

        # Update position with scaling
        self.float_x += current_move.x * SCALE_FACTOR
        self.float_y += current_move.y * SCALE_FACTOR
        self.rect.x = int(self.float_x)
        self.rect.y = int(self.float_y)
        
        # Move to next step in pattern
        self.move_index += 1

        # Check if enemy is off screen
        if (self.rect.bottom < 0 or self.rect.top > SCREEN_HEIGHT or 
            self.rect.right < 0 or self.rect.left > SCREEN_WIDTH):
            self.kill()
            
        return False
        
    def start_explosion(self):
        """Start the explosion animation sequence"""
        self.exploding = True
        self.bom_counter = 0
        self.bom_frame_counter = 0
        if self.explosion_frames:
            self.image = self.explosion_frames[0]

class EnemyManager:
    def __init__(self, resource_loader):
        self.enemies = pygame.sprite.Group()
        self.resource_loader = resource_loader
        
        # Load enemy data
        data_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'resources')
        move_dat_path = os.path.join(data_path, 'EneMove.DAT')
        happen_dat_path = os.path.join(data_path, 'Happen.DAT')
        
        # Always use default patterns for testing
        self.move_patterns = DataLoader.create_default_enemy_move_data()
        self.happen_data = DataLoader.create_default_enemy_happen_data()
        
        self.happen_counter = 0
        self.next_counter = 0
        print(f"Initialized with {len(self.happen_data)} happen events and {len(self.move_patterns)} movement patterns")
        
    def update(self):
        # Update existing enemies
        should_shoot = []
        for enemy in list(self.enemies):  # Create list to avoid modification during iteration
            if enemy.update():  # If True, enemy should shoot
                should_shoot.append(enemy)
        
        # Process enemy spawning
        self.next_counter += 1
        self._process_enemy_spawning()
        
        # Debug info
        if len(self.enemies) == 0 and self.next_counter % 60 == 0:  # Print every second if no enemies
            print(f"No enemies. Counter: {self.next_counter}, Happen counter: {self.happen_counter}")
        
        return should_shoot  # Return list of enemies that should shoot
        
    def draw(self, screen):
        self.enemies.draw(screen)
        
    def _process_enemy_spawning(self):
        """Process enemy spawning based on happen data"""
        if self.happen_counter >= len(self.happen_data):
            self.happen_counter = 0
            return

        happen = self.happen_data[self.happen_counter]
        
        # Handle special cases
        if happen.no == 255:  # End of data
            self.happen_counter = 0
            return
        elif happen.no == 256:  # Loop point
            if happen.power <= 0:  # Use power field for loop count
                self.happen_counter = 0  # Reset to beginning
            else:
                happen.power -= 1  # Decrease loop counter
                self.happen_counter = int(happen.x)  # Jump to specified position
            return
            
        # Check if it's time to spawn
        if self.next_counter >= happen.counter:
            self._spawn_enemy(happen)
            self.next_counter = 0
            self.happen_counter += 1

    def _spawn_enemy(self, happen_data: EnemyHappenData):
        """Spawn a new enemy based on happen data"""
        if len(self.enemies) >= MAX_ENEMIES:
            return
            
        # Calculate spawn position
        if happen_data.x == 700:  # Special value for random x position
            x = random.randint(0, int(SCREEN_WIDTH/SCALE_FACTOR) - 32)  # Use base size (32)
        else:
            x = happen_data.x
            
        # Get movement pattern, use pattern 0 if the requested pattern doesn't exist
        pattern_id = happen_data.no
        if pattern_id not in self.move_patterns or pattern_id >= len(self.move_patterns):
            pattern_id = 0
        
        # Get enemy sprite and mask from resource loader
        sprite_key = f'enemy_{pattern_id % 8}'  # Use enemy sprites from second row
        sprite = self.resource_loader.sprites.get(sprite_key)
        mask = self.resource_loader.sprite_masks.get(sprite_key)
        sprite_and_mask = (sprite, mask) if sprite else None

        if not sprite_and_mask:
            # Fallback to player sprite
            sprite = self.resource_loader.sprites.get('player_0')
            mask = self.resource_loader.sprite_masks.get('player_0')
            sprite_and_mask = (sprite, mask) if sprite else None
            
        # Create and add the enemy
        enemy = Enemy(
            x=x,
            y=happen_data.y,
            pattern_id=pattern_id,
            power=happen_data.power,
            move_data=self.move_patterns[pattern_id],
            sprite=sprite_and_mask,
            resource_loader=self.resource_loader
        )
        self.enemies.add(enemy)
        print(f"Spawned enemy at ({x}, {happen_data.y}) with pattern {pattern_id}")

    def get_enemies(self):
        return self.enemies
