import pygame
import sys
from game.game_state import GameState
from game.constants import *
from game.menu import MenuSystem

class Game:
    def __init__(self):
        pygame.init()
        pygame.mixer.init()
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        pygame.display.set_caption("Shooting Game")
        self.clock = pygame.time.Clock()
        self.game_state = None
        self.state = "MENU"
        self.font = pygame.font.Font(None, 28)  # Adjusted for new scale
        self.paused = False
        self.in_sound_settings = False

    def show_menu(self):
        title = self.font.render('Shooting Game', True, WHITE)
        title_rect = title.get_rect(center=(SCREEN_WIDTH/2, SCREEN_HEIGHT/3))
        
        start_text = self.font.render('Press SPACE to Start', True, WHITE)
        start_rect = start_text.get_rect(center=(SCREEN_WIDTH/2, SCREEN_HEIGHT*2/3))
        
        self.screen.fill((0, 0, 0))
        self.screen.blit(title, title_rect)
        self.screen.blit(start_text, start_rect)

    def show_game_over(self, score):
        game_over = self.font.render('Game Over', True, WHITE)
        game_over_rect = game_over.get_rect(center=(SCREEN_WIDTH/2, SCREEN_HEIGHT/3))
        
        score_text = self.font.render(f'Score: {score}', True, WHITE)
        score_rect = score_text.get_rect(center=(SCREEN_WIDTH/2, SCREEN_HEIGHT/2))
        
        restart_text = self.font.render('Press SPACE to Restart', True, WHITE)
        restart_rect = restart_text.get_rect(center=(SCREEN_WIDTH/2, SCREEN_HEIGHT*2/3))
        
        self.screen.fill((0, 0, 0))
        self.screen.blit(game_over, game_over_rect)
        self.screen.blit(score_text, score_rect)
        self.screen.blit(restart_text, restart_rect)

    def run(self):
        menu_system = None
        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()
                
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_SPACE:
                        if self.state in ["MENU", "GAME_OVER"]:
                            self.game_state = GameState()
                            self.state = "PLAYING"
                            self.paused = False
                            menu_system = MenuSystem(self.game_state.resource_loader.sound_manager)
                    elif event.key == pygame.K_ESCAPE and self.state == "PLAYING":
                        if self.in_sound_settings:
                            self.in_sound_settings = False
                        else:
                            self.paused = not self.paused
                            if self.paused:
                                self.game_state.resource_loader.sound_manager.pause_bgm()
                            else:
                                self.game_state.resource_loader.sound_manager.unpause_bgm()
                
                if self.state == "PLAYING":
                    if self.paused:
                        if self.in_sound_settings:
                            menu_system.handle_sound_settings(event)
                        else:
                            option = menu_system.handle_input(event)
                            if option == "Resume":
                                self.paused = False
                                self.game_state.resource_loader.sound_manager.unpause_bgm()
                            elif option == "Sound Settings":
                                self.in_sound_settings = True
                            elif option == "Quit to Title":
                                self.state = "MENU"
                                self.paused = False
                    else:
                        self.game_state.handle_event(event)

            if self.state == "PLAYING":
                if not self.paused:
                    self.game_state.update()
                self.screen.fill((0, 0, 0))
                self.game_state.draw(self.screen)
                if self.paused:
                    if self.in_sound_settings:
                        menu_system.draw_sound_settings(self.screen)
                    else:
                        menu_system.draw_pause_menu(self.screen)
            elif self.state == "MENU":
                self.show_menu()
            elif self.state == "GAME_OVER":
                self.show_game_over(self.game_state.score)

            pygame.display.flip()
            self.clock.tick(60)  # 60 FPS

if __name__ == "__main__":
    game = Game()
    game.run()

if __name__ == "__main__":
    game = Game()
    game.run()
