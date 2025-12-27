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
echo                Get-Winfig - Git Amend Helper
echo.

set /p EDIT_MSG="Do you want to edit the commit message? (y/n): "

if /i "%EDIT_MSG%"=="y" (
    set /p COMMIT_MSG="Enter your new commit message: "
    if "%COMMIT_MSG%"=="" (
        echo Please enter a valid commit message.
    ) else (
        git commit --amend -m "%COMMIT_MSG%"
    )
) else (
    git commit --amend --no-edit
)

echo Press any key to continue...
pause > nul
