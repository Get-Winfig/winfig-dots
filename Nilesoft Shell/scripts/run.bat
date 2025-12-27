@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

cls
echo.
echo   ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗
echo   ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝
echo   ██║ █╗ ██║██╔██╗ ██║█████╗  ██║██║  ███╗
echo   ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║
echo   ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝
echo    ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
echo.
echo         Get-Winfig - Universal Runner
echo.

REM Gather files
set count=0
for %%F in (*.py *.js *.ps1 *.sh *.bat *.cmd *.vbs *.wsf) do (
    set /a count+=1
    set "file!count!=%%F"
    echo   !count!. %%F
)

if %count%==0 (
    echo No runnable files found in this directory.
    pause
    exit /b
)

echo.
set /p choice="Select a file to run (number): "

if not defined file%choice% (
    echo Invalid selection.
    pause
    exit /b
)

set "selected=!file%choice%!"
echo.
echo Running: %selected%
echo.

REM Run with appropriate interpreter
for %%X in ("%selected%") do (
    set "ext=%%~xX"
)

if /i "%ext%"==".py" (
    uv run "%selected%"
) else if /i "%ext%"==".js" (
    node.exe "%selected%"
) else if /i "%ext%"==".ps1" (
    powershell.exe -ExecutionPolicy Bypass -File "%selected%"
) else if /i "%ext%"==".sh" (
    bash.exe "%selected%"
) else if /i "%ext%"==".bat" (
    call "%selected%"
) else if /i "%ext%"==".cmd" (
    call "%selected%"
) else if /i "%ext%"==".vbs" (
    cscript.exe //nologo "%selected%"
) else if /i "%ext%"==".wsf" (
    cscript.exe //nologo "%selected%"
) else (
    echo Unknown file type: %ext%
)

pause > nul
