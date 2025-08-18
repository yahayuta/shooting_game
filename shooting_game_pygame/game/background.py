import pygame
import random
from .constants import *

class StarDust:
    def __init__(self):
        self.x = random.randint(0, SCREEN_WIDTH)
        self.y = random.randint(0, SCREEN_HEIGHT)
        self.speed = random.randint(MIN_STAR_SPEED, MAX_STAR_SPEED)

class Background:
    def __init__(self):
        self.stars = []
        self.init_stars()
        
    def init_stars(self):
        """Initialize starfield background"""
        self.stars = [StarDust() for _ in range(MAX_STARDUST)]
        
    def update(self):
        """Update star positions"""
        for star in self.stars:
            star.y += star.speed
            if star.y > SCREEN_HEIGHT:
                star.y = 0
                star.x = random.randint(0, SCREEN_WIDTH)
                
    def draw(self, screen):
        """Draw background and stars"""
        screen.fill(BLACK)
        for star in self.stars:
            pygame.draw.rect(screen, WHITE, (star.x, star.y, 1, 1))
