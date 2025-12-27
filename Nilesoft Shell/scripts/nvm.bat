@echo off
chcp 65001 > nul

cls
echo.
echo   ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗
echo   ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝
echo   ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║██║  ███╗
echo   ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║
echo   ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝
echo    ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
echo.
echo                Get-Winfig - NVM Helper
echo.

REM Show the command being run
echo Running: nvm %*
echo.

nvm.exe %*

if errorlevel 1 (
    echo.
    echo NVM %* command failed with error level %errorlevel%
)  else (
    echo.
    echo NVM %* command run successfully
)

pause > nul

