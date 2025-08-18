import pygame
from .constants import *

class MenuSystem:
    def __init__(self, sound_manager):
        self.sound_manager = sound_manager
        self.font_large = pygame.font.Font(None, 36)  # Adjusted for new scale
        self.font_medium = pygame.font.Font(None, 24)  # Adjusted for new scale
        self.font_small = pygame.font.Font(None, 20)  # Adjusted for new scale
        self.selected_option = 0
        self.menu_items = []
        self.setup_main_menu()

    def setup_main_menu(self):
        """Set up the main menu options"""
        self.menu_items = [
            "Resume",
            "Sound Settings",
            "Quit to Title"
        ]

    def draw_pause_menu(self, screen):
        """Draw the pause menu"""
        # Draw semi-transparent background
        overlay = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        overlay.fill((0, 0, 0))
        overlay.set_alpha(128)
        screen.blit(overlay, (0, 0))

        # Draw "PAUSED" text
        pause_text = self.font_large.render("PAUSED", True, WHITE)
        text_rect = pause_text.get_rect(center=(SCREEN_WIDTH//2, SCREEN_HEIGHT//4))
        screen.blit(pause_text, text_rect)

        # Draw menu items
        for i, item in enumerate(self.menu_items):
            color = (255, 255, 0) if i == self.selected_option else WHITE
            text = self.font_medium.render(item, True, color)
            text_rect = text.get_rect(center=(SCREEN_WIDTH//2, SCREEN_HEIGHT//2 + i * 50))
            screen.blit(text, text_rect)

    def draw_sound_settings(self, screen):
        """Draw the sound settings menu"""
        # Draw semi-transparent background
        overlay = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        overlay.fill((0, 0, 0))
        overlay.set_alpha(128)
        screen.blit(overlay, (0, 0))

        # Draw title
        title = self.font_large.render("Sound Settings", True, WHITE)
        title_rect = title.get_rect(center=(SCREEN_WIDTH//2, SCREEN_HEIGHT//4))
        screen.blit(title, title_rect)

        # Draw volume controls
        bgm_text = self.font_small.render(f"BGM Volume: {int(self.sound_manager.music_volume * 100)}%", 
                                        True, WHITE)
        sfx_text = self.font_small.render(f"SFX Volume: {int(self.sound_manager.sound_volume * 100)}%", 
                                        True, WHITE)
        
        screen.blit(bgm_text, (SCREEN_WIDTH//4, SCREEN_HEIGHT//2))
        screen.blit(sfx_text, (SCREEN_WIDTH//4, SCREEN_HEIGHT//2 + 50))

        # Draw controls hint
        hint = self.font_small.render("← → to adjust, ESC to return", True, WHITE)
        hint_rect = hint.get_rect(center=(SCREEN_WIDTH//2, SCREEN_HEIGHT * 3//4))
        screen.blit(hint, hint_rect)

    def handle_input(self, event):
        """Handle menu input"""
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                self.selected_option = (self.selected_option - 1) % len(self.menu_items)
            elif event.key == pygame.K_DOWN:
                self.selected_option = (self.selected_option + 1) % len(self.menu_items)
            elif event.key == pygame.K_RETURN:
                return self.menu_items[self.selected_option]
        return None

    def handle_sound_settings(self, event):
        """Handle sound settings input"""
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                if self.selected_option == 0:  # BGM volume
                    self.sound_manager.set_music_volume(
                        max(0.0, self.sound_manager.music_volume - 0.1))
                else:  # SFX volume
                    self.sound_manager.set_sound_volume(
                        max(0.0, self.sound_manager.sound_volume - 0.1))
            elif event.key == pygame.K_RIGHT:
                if self.selected_option == 0:  # BGM volume
                    self.sound_manager.set_music_volume(
                        min(1.0, self.sound_manager.music_volume + 0.1))
                else:  # SFX volume
                    self.sound_manager.set_sound_volume(
                        min(1.0, self.sound_manager.sound_volume + 0.1))
            elif event.key == pygame.K_UP or event.key == pygame.K_DOWN:
                self.selected_option = (self.selected_option + 1) % 2
