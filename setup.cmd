@echo off
setlocal
echo ==============================================================================
echo 🚀 Initializing Windows Robot Framework Workspace Environment...
echo ==============================================================================

:: Verify Python installation presence in the system PATH matrix
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Fatal: Python interpreter not detected in PATH.
    echo Please install Python and ensure 'Add Python to PATH' is checked during setup.
    exit /b %errorlevel%
)

:: Validate dependency locking blueprint exists
if not exist "requirements.txt" (
    echo ❌ Fatal: requirements.txt configuration file is missing from root directory.
    exit /b 1
)

:: Form the isolated virtual environment folder structure
echo 📂 Provisioning clean virtual environment [venv]...
if exist venv (
    echo [INFO]: Overwriting existing venv directories...
)
python -m venv venv
if %errorlevel% neq 0 (
    echo ❌ Fatal: Virtual environment initialization routine failed.
    exit /b %errorlevel%
)

:: Activate the venv scope, update package engines, and deploy requirements
echo 📦 Syncing workspace packages...
call venv\Scripts\activate.bat && python -m pip install --upgrade pip && pip install -r requirements.txt

if %errorlevel% neq 0 (
    echo ❌ Fatal: Dependency allocation matrix script encountered failure.
    exit /b %errorlevel%
)

echo ==============================================================================
echo ✅ Workspace verification complete! Execute 'run_tests.cmd' to verify the suite.
echo ==============================================================================
endlocal
