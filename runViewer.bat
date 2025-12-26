@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =========================
REM Config
REM =========================
set "PORT=8000"
set "HTML=glb_viewer_stereo_full_controls_floor_anim_lights_ui_toggle_all.html"

REM Start in the folder where this .bat lives
cd /d "%~dp0"

REM =========================
REM Find Python
REM =========================
set "PY="
where python >nul 2>nul && set "PY=python"
if not defined PY (
  where py >nul 2>nul && set "PY=py -3"
)

if not defined PY (
  echo ERROR: Python not found. Install Python 3 from python.org and try again.
  pause
  exit /b 1
)

REM =========================
REM Start server in a new window
REM =========================
echo Starting local server on port %PORT% ...
start "Local Server" cmd /c %PY% -m http.server %PORT%

REM Give server a moment
timeout /t 1 /nobreak >nul

REM =========================
REM Ask user: Edge or Chrome?
REM =========================
:ASK
echo.
echo Open in which browser?
echo   [1] Microsoft Edge
echo   [2] Google Chrome / Chromium
echo   [Q] Quit
set /p "CHOICE=Enter choice (1/2/Q): "

if /I "%CHOICE%"=="Q" goto :DONE
if "%CHOICE%"=="1" goto :EDGE
if "%CHOICE%"=="2" goto :CHROME

echo Invalid choice. Try again.
goto :ASK

REM =========================
REM Locate and launch Edge
REM =========================
:EDGE
set "BROWSER="
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not defined BROWSER if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if not defined BROWSER (
  where msedge >nul 2>nul && set "BROWSER=msedge"
)

if not defined BROWSER (
  echo ERROR: Could not find Microsoft Edge.
  echo Open manually: http://localhost:%PORT%/%HTML%
  pause
  goto :DONE
)

start "" "%BROWSER%" "http://localhost:%PORT%/%HTML%"
goto :POST

REM =========================
REM Locate and launch Chrome/Chromium
REM =========================
:CHROME
set "BROWSER="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%LocalAppData%\Chromium\Application\chrome.exe" set "BROWSER=%LocalAppData%\Chromium\Application\chrome.exe"
if not defined BROWSER (
  where chrome >nul 2>nul && set "BROWSER=chrome"
)

if not defined BROWSER (
  echo ERROR: Could not find Chrome/Chromium.
  echo Open manually: http://localhost:%PORT%/%HTML%
  pause
  goto :DONE
)

start "" "%BROWSER%" "http://localhost:%PORT%/%HTML%"
goto :POST

REM =========================
REM Info
REM =========================
:POST
echo.
echo Server running at: http://localhost:%PORT%/
echo Viewer:          http://localhost:%PORT%/%HTML%
echo.
echo Close the "Local Server" window to stop the server.
echo.
pause
goto :DONE

:DONE
endlocal
exit /b 0
