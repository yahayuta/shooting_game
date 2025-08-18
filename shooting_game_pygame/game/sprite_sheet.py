import pygame
from .constants import *

class SpriteSheet:
    def __init__(self, image):
        """Initialize sprite sheet
        Args:
            image: pygame Surface containing the sprite sheet
        """
        self.sheet = image
        
    def get_sprite(self, x, y, width, height, use_mask=False):
        """Get a single sprite from the sheet
        Args:
            x, y: Top-left position of sprite in sheet
            width, height: Size of sprite
            use_mask: Whether to use the white mask area for collision
        Returns:
            sprite: The extracted sprite surface
            mask: Collision mask if use_mask is True, else None
        """
        # Create a new surface with per-pixel alpha
        sprite = pygame.Surface((width, height), pygame.SRCALPHA)
        
        # Copy the sprite from the sheet
        sprite.blit(self.sheet, (0, 0), (x, y, width, height))
        
        if use_mask:
            # Get the mask area (assumed to be below the sprite)
            mask_y = y + height
            mask_surface = pygame.Surface((width, height), pygame.SRCALPHA)
            mask_surface.blit(self.sheet, (0, 0), (x, mask_y, width, height))
            
            # Create collision mask from white area
            mask = pygame.mask.from_surface(mask_surface)
            return sprite, mask
        
        return sprite, None
    
    def get_sprite_strip(self, x, y, width, height, count, use_mask=False):
        """Get a strip of sprites starting from a specific position
        Args:
            x, y: Starting position in the sheet
            width, height: Size of each sprite
            count: Number of sprites to get
            use_mask: Whether to get collision masks
        Returns:
            List of (sprite, mask) tuples
        """
        sprites = []
        for i in range(count):
            sprite_x = x + (i * width)
            sprite, mask = self.get_sprite(sprite_x, y, width, height, use_mask)
            sprites.append((sprite, mask))
        return sprites
    
    def scale_sprite(self, sprite, scale_factor=None):
        """Scale a sprite while maintaining aspect ratio
        Args:
            sprite: Surface to scale
            scale_factor: Custom scale factor, uses SCALE_FACTOR if None
        Returns:
            Scaled sprite surface
        """
        if scale_factor is None:
            scale_factor = SCALE_FACTOR
            
        new_size = (
            int(sprite.get_width() * scale_factor),
            int(sprite.get_height() * scale_factor)
        )
        return pygame.transform.scale(sprite, new_size)
