import pygame
from .constants import *

def stick():
    """Emulate VB6's Stick function for 8-direction movement"""
    keys = pygame.key.get_pressed()
    key_tmp = 0
    
    # Check cardinal directions
    if keys[pygame.K_UP]:
        key_tmp = 1
    if keys[pygame.K_RIGHT]:
        key_tmp = 3
    if keys[pygame.K_DOWN]:
        key_tmp = 5
    if keys[pygame.K_LEFT]:
        key_tmp = 7
        
    # Check diagonals
    if keys[pygame.K_UP] and keys[pygame.K_RIGHT]:
        key_tmp = 2
    if keys[pygame.K_DOWN] and keys[pygame.K_RIGHT]:
        key_tmp = 4
    if keys[pygame.K_DOWN] and keys[pygame.K_LEFT]:
        key_tmp = 6
    if keys[pygame.K_UP] and keys[pygame.K_LEFT]:
        key_tmp = 8
        
    return key_tmp

class InputManager:
    @staticmethod
    def get_stick():
        return stick()
