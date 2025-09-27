@echo off
REM Go Architecture CLI Installation Script for Windows

setlocal EnableDelayedExpansion

set BINARY_NAME=go-arch-cli
set REPO=MdShimulMahmud/go-arch-cli
set INSTALL_DIR=%USERPROFILE%\bin

echo Go Architecture CLI Installation Script
echo ========================================

REM Create install directory if it doesn't exist
if not exist "%INSTALL_DIR%" (
    echo Creating install directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

REM Download binary
echo Downloading Go Architecture CLI...
set DOWNLOAD_URL=https://github.com/%REPO%/releases/latest/download/%BINARY_NAME%-windows-amd64.exe

REM Try to download using PowerShell
powershell -Command "try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%INSTALL_DIR%\%BINARY_NAME%.exe' -ErrorAction Stop; Write-Host 'Download successful' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to download binary. Please check your internet connection and try again.
    echo You can also build from source:
    echo   git clone https://github.com/%REPO%.git
    echo   cd go_cli
    echo   go build -o %BINARY_NAME%.exe
    pause
    exit /b 1
)

echo Installation completed successfully!
echo Binary installed to: %INSTALL_DIR%\%BINARY_NAME%.exe

REM Check if install directory is in PATH
echo %PATH% | findstr /i "%INSTALL_DIR%" >nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo WARNING: %INSTALL_DIR% is not in your PATH.
    echo To use %BINARY_NAME% from anywhere, add this directory to your PATH:
    echo   1. Open System Properties ^> Advanced ^> Environment Variables
    echo   2. Edit the PATH variable for your user
    echo   3. Add: %INSTALL_DIR%
    echo.
    echo Or run the tool directly: %INSTALL_DIR%\%BINARY_NAME%.exe
)

echo.
echo Try running: %BINARY_NAME% generate --help
pause