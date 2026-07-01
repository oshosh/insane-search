@echo off
:: Windows Installer for insane-search plugin & skill
echo [1/2] Installing plugin via Antigravity CLI...
agy.exe plugin install "%~dp0"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Antigravity CLI plugin installation failed.
    exit /b %ERRORLEVEL%
)

echo [2/2] Registering skill in global search path...
set "TARGET_DIR=%USERPROFILE%\.gemini\antigravity-cli\skills\insane-search"

:: Create directory if it does not exist
if not exist "%USERPROFILE%\.gemini\antigravity-cli\skills" (
    mkdir "%USERPROFILE%\.gemini\antigravity-cli\skills"
)

:: Clean up old files/links if exist
if exist "%TARGET_DIR%" (
    rmdir /s /q "%TARGET_DIR%" 2>nul
    del /f /q "%TARGET_DIR%" 2>nul
)

:: Create directory link to the deployed plugin skills folder
mklink /d "%TARGET_DIR%" "%USERPROFILE%\.gemini\config\plugins\insane-search\skills\insane-search"

if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Could not create symbolic link (requires admin privileges). Copying files instead...
    xcopy /e /i /y "%~dp0skills\insane-search" "%TARGET_DIR%"
)

echo [SUCCESS] insane-search installed and registered! Please restart your agy session.
