import pygame
import random
from .constants import *

class Explosion(pygame.sprite.Sprite):
    def __init__(self, x, y, resource_loader):
        super().__init__()
        self.resource_loader = resource_loader
        self.animation_frames = [self.resource_loader.sprites.get(f'explosion_{i}') for i in range(7)]
        
        self.frame_index = 0
        self.image = self.animation_frames[self.frame_index]
        if self.image:
            self.rect = self.image.get_rect()
            self.rect.center = (x, y)
        else:
            # Handle case where sprite is not found
            self.kill()

        self.animation_speed = 3  # Update frame every 3 game ticks, matching VB6
        self.animation_timer = 0

    def update(self):
        if not self.image:
            return

        self.animation_timer += 1
        if self.animation_timer >= self.animation_speed:
            self.animation_timer = 0
            self.frame_index += 1
            if self.frame_index >= len(self.animation_frames):
                self.kill()
            else:
                self.image = self.animation_frames[self.frame_index]
                if not self.image:
                    self.kill()

class ParticleSystem:
    def __init__(self, resource_loader):
        self.particles = pygame.sprite.Group()
        self.resource_loader = resource_loader
    
    def create_explosion(self, x, y):
        explosion = Explosion(x, y, self.resource_loader)
        self.particles.add(explosion)
    
    def update(self):
        self.particles.update()
    
    def draw(self, screen):
        self.particles.draw(screen)
