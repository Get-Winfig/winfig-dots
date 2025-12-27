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
echo                Get-Winfig - Git Clone Helper
echo.

set /p GIT_URL="Enter the Git repository URL (e.g., https://github.com/Get-Winfig/winfig-dots.git): "

if "%GIT_URL%"=="" (
    echo Please enter a valid Git repository URL.
) else (
    git clone %GIT_URL%
)

echo Press any key to continue...
pause > nul
