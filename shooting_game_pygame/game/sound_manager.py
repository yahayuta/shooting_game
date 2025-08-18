import os
import pygame
from pathlib import Path

class SoundManager:
    def __init__(self):
        self.sounds = {}
        self.bgm_loaded = False
        self.bgm_playing = False
        
        # Initialize mixer with settings good for both WAV and MIDI
        pygame.mixer.init(44100, -16, 2, 512)
        
        # Set default volumes
        self.sound_volume = 1.0
        self.music_volume = 0.7
        pygame.mixer.music.set_volume(self.music_volume)

    def add_sound(self, sound_name: str, sound_path: str):
        """Add a sound effect to the manager"""
        try:
            self.sounds[sound_name] = pygame.mixer.Sound(sound_path)
            self.sounds[sound_name].set_volume(self.sound_volume)
        except pygame.error as e:
            print(f"Error loading sound {sound_name} from {sound_path}: {e}")

    def load_sounds(self, resource_path: Path):
        """Load all game sounds"""
        try:
            # Load WAV sound effects
            sound1_path = resource_path / 'Sound1.wav'
            if sound1_path.exists():
                self.sounds['explosion'] = pygame.mixer.Sound(str(sound1_path))
                self.sounds['hit'] = self.sounds['explosion']  # Share same sound
                # Set volume for all sounds
                for sound in self.sounds.values():
                    sound.set_volume(self.sound_volume)
        except pygame.error as e:
            print(f"Error loading sound effects: {e}")

        try:
            # Load MIDI background music
            bgm_path = resource_path / 'Bgm.mid'
            if bgm_path.exists():
                pygame.mixer.music.load(str(bgm_path))
                self.bgm_loaded = True
            else:
                print("BGM file not found")
                self.bgm_loaded = False
        except pygame.error as e:
            print(f"Error loading BGM: {e}")
            self.bgm_loaded = False

    def play_sound(self, sound_name: str):
        """Play a sound effect"""
        if sound_name in self.sounds:
            try:
                self.sounds[sound_name].play()
            except pygame.error as e:
                print(f"Error playing sound {sound_name}: {e}")

    def play_bgm(self, loops: int = -1):
        """Start playing background music"""
        if self.bgm_loaded and not self.bgm_playing:
            try:
                pygame.mixer.music.play(loops)  # -1 means loop indefinitely
                self.bgm_playing = True
            except pygame.error as e:
                print(f"Error playing BGM: {e}")

    def stop_bgm(self):
        """Stop background music"""
        if self.bgm_playing:
            try:
                pygame.mixer.music.stop()
                self.bgm_playing = False
            except pygame.error as e:
                print(f"Error stopping BGM: {e}")

    def pause_bgm(self):
        """Pause background music"""
        if self.bgm_playing:
            try:
                pygame.mixer.music.pause()
            except pygame.error as e:
                print(f"Error pausing BGM: {e}")

    def unpause_bgm(self):
        """Unpause background music"""
        if self.bgm_playing:
            try:
                pygame.mixer.music.unpause()
            except pygame.error as e:
                print(f"Error unpausing BGM: {e}")

    def set_sound_volume(self, volume: float):
        """Set volume for sound effects (0.0 to 1.0)"""
        self.sound_volume = max(0.0, min(1.0, volume))
        for sound in self.sounds.values():
            sound.set_volume(self.sound_volume)

    def set_music_volume(self, volume: float):
        """Set volume for background music (0.0 to 1.0)"""
        self.music_volume = max(0.0, min(1.0, volume))
        pygame.mixer.music.set_volume(self.music_volume)
