@echo off
title Hytale Launcher

REM ===================================================================
REM Hytale Launcher Batch Script (Offline)
REM ===================================================================
REM This script launches the Hytale client from an offline build
REM It handles:
REM   - Setting working directories
REM   - UserData folder creation
REM   - Selecting player name
REM   - Optional UUID override
REM   - Launching the game with correct paths
REM ===================================================================

REM -------------------------------------------------------------------
REM Set Hytale directory to the folder where this batch file is located
REM %~dp0 expands to the full path of the batch file's directory
REM -------------------------------------------------------------------
set "HYTALE_DIR=%~dp0"

REM -------------------------------------------------------------------
REM Remove trailing backslash if present (standardize path)
REM -------------------------------------------------------------------
if "%HYTALE_DIR:~-1%"=="\" set "HYTALE_DIR=%HYTALE_DIR:~0,-1%"

REM -------------------------------------------------------------------
REM Determine player name
REM Default: current Windows username (%USERNAME%)
REM Override: first argument passed to batch file (%~1)
REM -------------------------------------------------------------------
set "PLAYER_NAME=%USERNAME%"
if not "%~1"=="" set "PLAYER_NAME=%~1"

REM -------------------------------------------------------------------
REM Determine UUID
REM Default: fixed UUID
REM Override: second argument passed to batch file (%~2)
REM -------------------------------------------------------------------
set "UUID=00000000-0000-0000-0000-000000000000"
if not "%~2"=="" set "UUID=%~2"

REM -------------------------------------------------------------------
REM Ensure UserData folder exists
REM Used by Hytale to store player settings and local data
REM -------------------------------------------------------------------
if not exist "%HYTALE_DIR%\UserData" mkdir "%HYTALE_DIR%\UserData"

REM -------------------------------------------------------------------
REM Verify Hytale client exists
REM Prevents launching if HytaleClient.exe is missing
REM Exits with error and pause for debugging
REM -------------------------------------------------------------------
if not exist "%HYTALE_DIR%\game\data\Client\HytaleClient.exe" (
    echo ERROR: HytaleClient.exe not found in "%HYTALE_DIR%\game\data\Client"
    echo.
    pause
    exit /b 1
)

REM -------------------------------------------------------------------
REM Display launch information
REM Shows player name and UUID being used
REM -------------------------------------------------------------------
echo Launching Hytale for player "%PLAYER_NAME%" with UUID "%UUID%"...
echo.

REM -------------------------------------------------------------------
REM Launch Hytale client
REM Arguments:
REM   --app-dir     : path to game data folder
REM   --user-dir    : path to user data folder
REM   --java-exec   : embedded JRE path
REM   --auth-mode   : offline authentication
REM   --uuid        : fixed UUID for offline play
REM   --name        : player name
REM Paths are relative to HYTALE_DIR to support offline builds
REM -------------------------------------------------------------------
start "" "%HYTALE_DIR%\game\data\Client\HytaleClient.exe" ^
  --app-dir "%HYTALE_DIR%\game\data" ^
  --user-dir "%HYTALE_DIR%\UserData" ^
  --java-exec "%HYTALE_DIR%\game\jre\bin\java.exe" ^
  --auth-mode offline ^
  --uuid "%UUID%" ^
  --name "%PLAYER_NAME%"

REM -------------------------------------------------------------------
REM Exit the launcher batch script immediately
REM -------------------------------------------------------------------
exit
