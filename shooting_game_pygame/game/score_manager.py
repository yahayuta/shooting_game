import os
import json
from pathlib import Path

class ScoreManager:
    def __init__(self):
        self.save_dir = self._get_save_directory()
        self.scores_file = self.save_dir / 'scores.json'
        self.high_score = 0
        self.load_scores()

    def _get_save_directory(self) -> Path:
        """Get the appropriate save directory for the platform"""
        if os.name == 'nt':  # Windows
            save_dir = Path(os.getenv('APPDATA')) / 'ShootingGame'
        else:  # Linux/Mac
            save_dir = Path.home() / '.shootinggame'
            
        # Create directory if it doesn't exist
        save_dir.mkdir(parents=True, exist_ok=True)
        return save_dir

    def load_scores(self):
        """Load high scores from file"""
        try:
            if self.scores_file.exists():
                with open(self.scores_file, 'r') as f:
                    data = json.load(f)
                    self.high_score = data.get('high_score', 0)
            else:
                self.high_score = 0
        except Exception as e:
            print(f"Error loading scores: {e}")
            self.high_score = 0

    def save_scores(self):
        """Save high scores to file"""
        try:
            with open(self.scores_file, 'w') as f:
                json.dump({
                    'high_score': self.high_score
                }, f)
        except Exception as e:
            print(f"Error saving scores: {e}")

    def update_score(self, new_score: int):
        """Update high score if necessary"""
        if new_score > self.high_score:
            self.high_score = new_score
            self.save_scores()
            return True
        return False

    def get_high_score(self) -> int:
        """Get the current high score"""
        return self.high_score
