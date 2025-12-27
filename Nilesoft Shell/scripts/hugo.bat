@echo off
chcp 65001 > nul

cls
echo.
echo   ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗
echo   ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝
echo   ██║ █╗ ██║██╔██╗ ██║█████╗  ██║██║  ███╗
echo   ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║
echo   ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝
echo    ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
echo.
echo                Get-Winfig - Hugo Helper
echo.

REM Handle 'new site'
if /i "%1 %2"=="new site" (
    set SITENAME=%3
    if "%SITENAME%"=="" (
        set /p SITENAME="Enter new site name: "
    )
    echo Running: hugo new site "%SITENAME%"
    hugo.exe new site "%SITENAME%"
    goto :end
)

REM Handle 'new post'
if /i "%1 %2"=="new post" (
    set POSTNAME=%3
    if "%POSTNAME%"=="" (
        set /p POSTNAME="Enter new post name (e.g. MyNewPost.md): "
    )
    echo Running: hugo new post "%POSTNAME%"
    hugo.exe new post "%POSTNAME%"
    goto :end
)

REM Default: pass all arguments to hugo
echo Running: hugo %*
hugo.exe %*

:end
if errorlevel 1 (
    echo.
    echo Hugo %* command failed with error level %errorlevel%
)  else (
    echo.
    echo Hugo %* command run successfully
)

pause > nul

