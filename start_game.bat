@echo off
cd /d "%~dp0"
if not exist .venv (
    python -m venv .venv
    call .venv\Scripts\activate.bat
    python -m pip install pygame numpy
) else (
    call .venv\Scripts\activate.bat
)
python shooting_game_pygame\main.py
pause
