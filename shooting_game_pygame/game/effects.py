import pygame
import random
from .constants import *

class Explosion(pygame.sprite.Sprite):
    def __init__(self, x, y, size=30):
        super().__init__()
        self.size = size
        self.image = pygame.Surface([size, size])
        self.image.fill((255, 165, 0))  # Orange
        self.image.set_colorkey((0, 0, 0))
        self.rect = self.image.get_rect()
        self.rect.center = (x, y)
        self.frame = 0
        self.max_frame = 8
        self.alpha = 255

    def update(self):
        self.frame += 1
        if self.frame >= self.max_frame:
            self.kill()
        else:
            # Create explosion animation effect
            self.alpha = 255 * (1 - self.frame / self.max_frame)
            self.image.set_alpha(self.alpha)
            new_size = int(self.size * (1 + self.frame / self.max_frame))
            old_center = self.rect.center
            self.image = pygame.Surface([new_size, new_size])
            self.image.fill((255, 165, 0))
            self.image.set_colorkey((0, 0, 0))
            self.image.set_alpha(self.alpha)
            self.rect = self.image.get_rect()
            self.rect.center = old_center

class ParticleSystem:
    def __init__(self):
        self.particles = pygame.sprite.Group()
    
    def create_explosion(self, x, y, size=30):
        explosion = Explosion(x, y, size)
        self.particles.add(explosion)
    
    def update(self):
        self.particles.update()
    
    def draw(self, screen):
        self.particles.draw(screen)
