@echo off
setlocal

cd /d "%~dp0"

echo ==========================================
echo Plugin Host - GraalVM Native Build and Run
echo ==========================================
echo Project Directory: %CD%
echo.

REM --------------------------------------------------
REM Verify Java
REM --------------------------------------------------

where java >nul 2>&1
if errorlevel 1 (
echo ERROR: Java/GraalVM not found in PATH.
pause
exit /b 1
)

REM --------------------------------------------------
REM Verify Native Image
REM --------------------------------------------------

where native-image >nul 2>&1
if errorlevel 1 (
echo ERROR: GraalVM Native Image not found.
echo Please install GraalVM Native Image.
pause
exit /b 1
)

REM --------------------------------------------------
REM Locate Visual Studio Build Tools
REM --------------------------------------------------

echo Checking Visual Studio C++ Build Tools...

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist "%VSWHERE%" (
echo ERROR: vswhere.exe not found.
echo Please install Visual Studio Build Tools.
pause
exit /b 1
)

for /f "usebackq delims=" %%i in (`    "%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
set "VS_PATH=%%i"
)

if not defined VS_PATH (
echo ERROR: Visual Studio C++ Build Tools not found.
echo Install Desktop Development with C++ workload.
pause
exit /b 1
)

echo Visual Studio Found:
echo %VS_PATH%
echo.

call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x64

if errorlevel 1 (
echo ERROR: Failed to initialize Visual Studio environment.
pause
exit /b 1
)

echo.
echo ==========================================
echo Building GraalVM Native Image
echo ==========================================
echo.

call gradlew.bat clean nativeCompile

if errorlevel 1 (
echo.
echo ERROR: Native build failed.
pause
exit /b 1
)

REM --------------------------------------------------
REM Native Executable Path
REM --------------------------------------------------

set "EXECUTABLE=%CD%\build\native\nativeCompile\plugin-host.exe"

if not exist "%EXECUTABLE%" (
echo.
echo ERROR: Native executable not found.
echo Expected:
echo %EXECUTABLE%
pause
exit /b 1
)

echo.
echo ==========================================
echo Running Native Executable
echo ==========================================
echo.

call "%EXECUTABLE%"

if errorlevel 1 (
echo.
echo ERROR: Native executable failed.
pause
exit /b 1
)

echo.
echo ==========================================
echo Execution Completed Successfully
echo ==========================================

pause
endlocal
