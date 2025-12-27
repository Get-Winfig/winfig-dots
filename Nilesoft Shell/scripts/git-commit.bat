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
echo                Get-Winfig - Git Commit Helper
echo.

set /p COMMIT_MSG="Enter your commit message: "

if "%COMMIT_MSG%"=="" (
    echo Please enter a valid commit message.
) else (
    git commit -m "%COMMIT_MSG%"
)

echo Press any key to continue...
pause > nul
