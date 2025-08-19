# Shooting Game

This project is a classic 2D shooting game, with two implementations: one in Python using the Pygame library, and another in Visual Basic 6.

## Features

*   Classic 2D top-down shooter gameplay.
*   Player-controlled ship with shooting mechanics.
*   Enemy ships with predefined movement patterns.
*   Scoring system.
*   Main menu and game over screens.
*   Sound effects and background music.

## Versions

This repository contains two versions of the game:

### 1. Python (Pygame) Version

Located in the `shooting_game_pygame` directory, this is a modern implementation of the game using Python and the Pygame library.

**How to Run:**

1.  Make sure you have Python installed.
2.  Install the required library, Pygame:
    ```bash
    pip install pygame
    ```
3.  Navigate to the project's root directory.
4.  Run the game using the `start_game.bat` batch file, or by executing the following command:
    ```bash
    python -m shooting_game_pygame.main
    ```

### 2. Visual Basic 6 Version

Located in the `shooting_game_vb6` directory, this is the original version of the game developed in Visual Basic 6.

**How to Run:**

*   You can run the pre-compiled executable directly: `shooting_game_vb6/Shooting.exe`.
*   To open and edit the project, you will need a Visual Basic 6 development environment. The main project file is `shooting_game_vb6/Shooting.vbp`.

## Modernization and Design

While both versions share the same core concept, the Pygame version is a significant modernization and not a direct 1:1 port of the VB6 original. The game's data structures and design have been fundamentally updated:

*   **Enemy Movement:** The VB6 version uses rigid, step-by-step paths for each enemy type, defined in binary `.DAT` files. The Pygame version replaces this with a dynamic, behavior-based system using JSON files, defining patterns like "sine wave" or "linear" movement.
*   **Game Events:** The VB6 version uses a timeline of discrete spawn events. The Pygame version implements a more flexible, time-based event system (e.g., "spawn_wave") defined in a JSON file.
*   **Explosion System:** The original VB6 explosion, a 7-frame sprite-based animation, has been accurately migrated to the Pygame version, replacing a previous procedural particle effect.

The `DAT_EXPORT.bas` module in the VB6 project was likely a utility used to analyze the original game data, which then inspired the new, modernized system in the Pygame version.

## Project Structure

```
.
├── shooting_game_pygame/   # Python/Pygame version
│   ├── main.py             # Main game entry point
│   ├── game/               # Game logic modules
│   └── resources/          # Game assets (images, sounds)
├── shooting_game_vb6/      # Visual Basic 6 version
│   ├── Shooting.vbp        # VB6 project file
│   ├── MainForm.frm        # Main form for the game
│   └── Shooting.exe        # Compiled executable
├── .gitignore
├── README.md
└── start_game.bat
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)