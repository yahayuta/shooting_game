# Screen dimensions (scaled up from original VB6 for better visibility)
SCREEN_WIDTH = 384  # 1.5x of original 256
SCREEN_HEIGHT = 480  # 1.5x of original 320

# Display scaling
SCALE_FACTOR = 1.5  # More moderate scaling factor

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)

# Game settings
FPS = 60
CYCLE_TIME = 25  # VB6's cycle time in milliseconds
PLAYER_SPEED = int(8 * SCALE_FACTOR)  # Scaled from original VB6 speed
BULLET_SPEED = int(12 * SCALE_FACTOR)  # Scaled from original VB6 speed

# Sprite settings
BASE_SPRITE_SIZE = 32  # Base size for sprites
SPRITE_SCALE = 1.0    # Additional sprite-specific scaling

# Player settings
PLAYER_WIDTH = int(BASE_SPRITE_SIZE * SPRITE_SCALE)  # Base size without display scaling
PLAYER_HEIGHT = int(BASE_SPRITE_SIZE * SPRITE_SCALE) # Base size without display scaling
PLAYER_SHOOT_DELAY = 3  # From VB6: Counter = 3

# Enemy settings
MAX_ENEMIES = 20  # From VB6: EnemyMax = 20
MAX_ENEMY_SHOTS = 40  # From VB6: EneShotMax = 40

# Background settings
MAX_STARDUST = 20  # From VB6: MaxDust = 20
MIN_STAR_SPEED = 2
MAX_STAR_SPEED = 6
