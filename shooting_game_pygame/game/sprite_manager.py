import pygame
import math
from .constants import *

class SpriteManager:
    """Handles sprite creation and animation"""
    
    @staticmethod
    def create_explosion_frames(base_size):
        """Create explosion animation frames"""
        frames = []
        for i in range(7):  # 7 frames of explosion
            frame = pygame.Surface([base_size, base_size], pygame.SRCALPHA)
            
            # Calculate explosion properties
            size = int(base_size * (0.3 + i * 0.2))  # Start small and grow
            alpha = 255 - (i * 30)  # Fade out
            
            # Create gradient colors for explosion
            colors = [
                (255, 200, 0, alpha),    # Yellow core
                (255, 100, 0, alpha),    # Orange middle
                (255, 0, 0, alpha-40)    # Red outer
            ]
            
            # Draw explosion circles with gradient
            center = (base_size // 2, base_size // 2)
            for idx, color in enumerate(colors):
                radius = size // (idx + 2)
                pygame.draw.circle(frame, color, center, radius)
            
            frames.append(frame)
        return frames

    @staticmethod
    def create_bullet(width, height, color=WHITE):
        """Create a bullet sprite"""
        surface = pygame.Surface((width, height), pygame.SRCALPHA)
        
        # Draw bullet with gradient
        rect = surface.get_rect()
        start_color = color
        end_color = (color[0]//2, color[1]//2, color[2]//2)
        
        for y in range(height):
            current_color = [
                int(start_color[i] + (end_color[i] - start_color[i]) * (y/height))
                for i in range(3)
            ]
            pygame.draw.line(surface, current_color, (0, y), (width-1, y))
        
        return surface

    @staticmethod
    def apply_hit_effect(sprite):
        """Create hit effect version of a sprite"""
        effect = sprite.copy()
        # Create white flash effect
        white_overlay = pygame.Surface(sprite.get_size(), pygame.SRCALPHA)
        white_overlay.fill((255, 255, 255, 128))
        effect.blit(white_overlay, (0, 0))
        return effect

    @staticmethod
    def create_shield_effect(size):
        """Create shield effect surface"""
        shield = pygame.Surface((size, size), pygame.SRCALPHA)
        center = size // 2
        
        # Draw shield circles
        for i in range(2):
            radius = center - i * 2
            color = (0, 255, 255, 128 - i * 30)
            pygame.draw.circle(shield, color, (center, center), radius, 2)
        
        return shield
