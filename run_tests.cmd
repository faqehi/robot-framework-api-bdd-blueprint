@echo off
setlocal

:: Accept target environment argument (%1), default to 'test' if left empty
set TARGET_ENV=%1
if "%TARGET_ENV%"=="" set TARGET_ENV=test

echo ==============================================================================
echo 🎭 Executing Robot Framework API Test Suite against: [%TARGET_ENV%]
echo ==============================================================================

:: Ensure the local virtual environment exists before attempting activation
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Error: Virtual environment not found. Please execute setup.cmd first.
    exit /b 1
)

:: 1. Force Python module lookup context to look into your 'src' layer
set PYTHONPATH=src

:: 2. Activate the isolated virtual environment scope and run the suite natively
cmd /c "venv\Scripts\activate.bat && robot --variable ENV:%TARGET_ENV% --outputdir test-results/ tests/restful_booker_bdd.robot"

endlocal
