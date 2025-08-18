import os
import struct
from dataclasses import dataclass
from typing import List, Dict

@dataclass
class EnemyMoveData:
    x: float
    y: float
    flag: int

@dataclass
class EnemyHappenData:
    x: float
    y: float
    no: int
    counter: int
    power: int

class DataLoader:
    @staticmethod
    def load_enemy_move_data(file_path: str) -> Dict[int, List[EnemyMoveData]]:
        """Load enemy movement patterns from EneMove.DAT"""
        patterns = {}
        try:
            with open(file_path, 'rb') as f:
                # EneMove(0 To 20, 0 To 255) in VB6
                for pattern_id in range(21):  # 0 to 20
                    moves = []
                    for step in range(256):  # 0 to 255
                        # Each record contains x (Single), y (Single), flag (Byte)
                        x = struct.unpack('f', f.read(4))[0]
                        y = struct.unpack('f', f.read(4))[0]
                        flag = struct.unpack('B', f.read(1))[0]
                        moves.append(EnemyMoveData(x, y, flag))
                    patterns[pattern_id] = moves
        except Exception as e:
            print(f"Error loading enemy move data: {e}")
            # Create default pattern if file can't be loaded
            patterns[0] = [EnemyMoveData(0.0, 2.0, 0) for _ in range(256)]
        return patterns

    @staticmethod
    def load_enemy_happen_data(file_path: str) -> List[EnemyHappenData]:
        """Load enemy spawn patterns from Happen.DAT"""
        happens = []
        try:
            with open(file_path, 'rb') as f:
                # EneHappen(0 To 255) in VB6
                for _ in range(256):
                    # Each record contains x (Single), y (Single), no (Integer), counter (Integer), power (Byte)
                    x = struct.unpack('f', f.read(4))[0]
                    y = struct.unpack('f', f.read(4))[0]
                    no = struct.unpack('h', f.read(2))[0]  # Integer in VB6 is 16-bit
                    counter = struct.unpack('h', f.read(2))[0]
                    power = struct.unpack('B', f.read(1))[0]
                    happens.append(EnemyHappenData(x, y, no, counter, power))
        except Exception as e:
            print(f"Error loading enemy happen data: {e}")
            # Create default pattern if file can't be loaded
            happens = [EnemyHappenData(0.0, 0.0, 255, 0, 0)]  # 255 means end in VB6
        return happens

    @staticmethod
    def create_default_enemy_move_data():
        """Create default movement patterns if DAT file is not available"""
        patterns = {
            0: [],  # Straight down
            1: [],  # Sine wave
            2: [],  # Circle
            3: []   # Zigzag
        }
        
        # Pattern 0: Straight down
        for i in range(256):
            patterns[0].append(EnemyMoveData(0.0, 2.0, 0 if i < 255 else 255))
            
        # Pattern 1: Sine wave
        import math
        for i in range(256):
            x = math.sin(i * 0.1) * 2.0
            patterns[1].append(EnemyMoveData(x, 1.5, 0 if i < 255 else 255))
            
        # Pattern 2: Circle
        for i in range(256):
            angle = i * 0.1
            x = math.cos(angle) * 2.0
            y = 1.0 + math.sin(angle) * 0.5
            patterns[2].append(EnemyMoveData(x, y, 0 if i < 255 else 255))
            
        # Pattern 3: Zigzag
        for i in range(256):
            x = 2.0 if (i // 30) % 2 == 0 else -2.0
            patterns[3].append(EnemyMoveData(x, 1.5, 0 if i < 255 else 255))
            
        return patterns

    @staticmethod
    def create_default_enemy_happen_data():
        """Create default spawn patterns if DAT file is not available"""
        happens = []
        
        # Create a simple repeating pattern
        for i in range(256):
            if i < 50:  # First 50 entries are actual spawn data
                x = 700.0 if i % 5 == 0 else (i * 10.0)  # 700 means random x in VB6
                y = 0.0
                no = i % 4  # Use one of our 4 patterns
                counter = 30 + (i % 3) * 10  # Spawn every 30-50 frames
                power = 1 + (i // 10)  # Increase power every 10 enemies
                happens.append(EnemyHappenData(x, y, no, counter, power))
            elif i == 50:
                # Add loop back to start
                happens.append(EnemyHappenData(0.0, 0.0, 256, 0, 0))  # 256 means loop in VB6
            else:
                # Fill rest with end markers
                happens.append(EnemyHappenData(0.0, 0.0, 255, 0, 0))  # 255 means end in VB6
        
        return happens
