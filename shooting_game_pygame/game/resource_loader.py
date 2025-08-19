import os
import pygame
import json
from pathlib import Path
from .sound_manager import SoundManager
from .sprite_sheet import SpriteSheet

class ResourceLoader:
    def __init__(self):
        self.base_path = Path(__file__).parent.parent
        self.resource_path = self.base_path / 'resources'
        self.images = {}
        self.sprites = {}  # Store sprite variations
        self.sprite_masks = {}  # Store collision masks
        self.sounds = {}  # Keep this for compatibility
        self.sound_manager = SoundManager()
        self.enemy_data = None
        self.event_data = None

    def load_images(self):
        """Load all image resources"""
        from .constants import (SCALE_FACTOR, PLAYER_WIDTH, PLAYER_HEIGHT, 
                              SCREEN_HEIGHT, SCREEN_WIDTH, BASE_SPRITE_SIZE)
        
        sprite_sheets = {
            'ships': {
                'file': 'Shooting.gif',
                'sprites': [
                    # Player sprite: y=64-96, x=0-32
                    {
                        'type': 'player',
                        'x': 0,
                        'y': 64,
                        'width': 32,
                        'height': 32,
                        'count': 1,
                        'use_mask': True
                    },
                    # Enemy sprites: y=0-32, x=0-224
                    {
                        'type': 'enemy',
                        'x': 0,
                        'y': 0,
                        'width': 32,
                        'height': 32,
                        'count': 7,
                        'use_mask': True
                    },
                    # Explosion sprites: y=224-256, x=128-256 (4 frames)
                    {
                        'type': 'explosion',
                        'x': 0,
                        'y': 128,
                        'width': 32,
                        'height': 32,
                        'count': 7,  # 7 explosion frames in VB6
                        'use_mask': False
                    }
                ]
            }
        }
        
        # Load sprite sheets
        for sheet_name, sheet_info in sprite_sheets.items():
            path = self.resource_path / sheet_info['file']
            try:
                # Load the sprite sheet
                sheet_image = pygame.image.load(str(path)).convert_alpha()
                sprite_sheet = SpriteSheet(sheet_image)
                
                # Process each sprite definition
                for sprite_info in sheet_info['sprites']:
                    sprites = sprite_sheet.get_sprite_strip(
                        x=sprite_info['x'],
                        y=sprite_info['y'],
                        width=sprite_info['width'],
                        height=sprite_info['height'],
                        count=sprite_info['count'],
                        use_mask=sprite_info['use_mask']
                    )
                    
                    # Store sprites and masks
                    for i, (sprite, mask) in enumerate(sprites):
                        # Scale the sprite
                        scaled_sprite = sprite_sheet.scale_sprite(sprite)
                        
                        sprite_key = f"{sprite_info['type']}_{i}"
                        self.sprites[sprite_key] = scaled_sprite
                        if mask:
                            self.sprite_masks[sprite_key] = mask
                
                # Set the main player sprite
                self.images['player'] = self.sprites['player_0']
                
            except Exception as e:
                print(f"Error loading sprite sheet {sheet_name}: {e}")
                # Create placeholder sprite
                size = (int(32 * SCALE_FACTOR), int(32 * SCALE_FACTOR))
                placeholder = pygame.Surface(size, pygame.SRCALPHA)
                placeholder.fill((255, 0, 0, 128))
                self.images['player'] = placeholder
        
        # Load other images
        other_images = {
            'background': 'B_Pic.gif',
            'message': 'Message.gif'
        }
        
        for key, filename in other_images.items():
            path = self.resource_path / filename
            try:
                original_image = pygame.image.load(str(path)).convert_alpha()
                
                if key == 'background':
                    # Scale background to screen size
                    self.images[key] = pygame.transform.scale(
                        original_image, (SCREEN_WIDTH, SCREEN_HEIGHT)
                    )
                else:
                    # Other images: maintain aspect ratio
                    aspect_ratio = original_image.get_width() / original_image.get_height()
                    base_height = 32
                    new_height = int(base_height * SCALE_FACTOR)
                    new_width = int(new_height * aspect_ratio)
                    self.images[key] = pygame.transform.scale(
                        original_image, (new_width, new_height)
                    )
            except pygame.error as e:
                print(f"Couldn't load image {filename}: {e}")
                # Create placeholder sprite
                size = (int(32 * SCALE_FACTOR), int(32 * SCALE_FACTOR))
                placeholder = pygame.Surface(size, pygame.SRCALPHA)
                placeholder.fill((255, 0, 0, 128))
                self.images[key] = placeholder

    def load_sounds(self):
        """Load all sound resources"""
        sound_files = {
            'explosion': 'Sound1.wav',
            'bgm': 'Bgm.mid'
        }
        
        for key, filename in sound_files.items():
            path = self.resource_path / filename
            try:
                if filename.endswith('.mid'):
                    pygame.mixer.music.load(str(path))
                else:
                    self.sound_manager.add_sound(key, str(path))
            except pygame.error as e:
                print(f"Couldn't load sound {filename}: {e}")

    def load_enemy_data(self):
        """Load enemy movement patterns"""
        try:
            # We'll create a new JSON-based format for enemy data
            data_path = self.resource_path / 'enemy_patterns.json'
            if data_path.exists():
                with open(data_path, 'r') as f:
                    self.enemy_data = json.load(f)
            else:
                # Default pattern if file doesn't exist
                self.enemy_data = {
                    "patterns": [
                        {
                            "id": 1,
                            "movement": "sine",
                            "speed": 2,
                            "amplitude": 100
                        },
                        {
                            "id": 2,
                            "movement": "linear",
                            "speed": 3,
                            "angle": 45
                        }
                    ]
                }
                # Save default patterns
                with open(data_path, 'w') as f:
                    json.dump(self.enemy_data, f, indent=4)
        except Exception as e:
            print(f"Error loading enemy data: {e}")
            self.enemy_data = {"patterns": []}

    def load_event_data(self):
        """Load game events and triggers"""
        try:
            # We'll create a new JSON-based format for event data
            data_path = self.resource_path / 'game_events.json'
            if data_path.exists():
                with open(data_path, 'r') as f:
                    self.event_data = json.load(f)
            else:
                # Default events if file doesn't exist
                self.event_data = {
                    "events": [
                        {
                            "time": 0,
                            "type": "spawn_wave",
                            "enemy_count": 5,
                            "pattern_id": 1
                        }
                    ]
                }
                # Save default events
                with open(data_path, 'w') as f:
                    json.dump(self.event_data, f, indent=4)
        except Exception as e:
            print(f"Error loading event data: {e}")
            self.event_data = {"events": []}
