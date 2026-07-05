#!/bin/bash
set -e

# Accept target environment argument ($1), default to 'test' if left empty
TARGET_ENV=${1:-test}

echo "=============================================================================="
echo "🎭 Executing Robot Framework API Test Suite against: [${TARGET_ENV^^}]"
echo "=============================================================================="

# Ensure the local virtual environment exists before attempting activation
if [ ! -f "venv/bin/activate" ]; then
    echo "❌ Error: Virtual environment not found. Please execute ./setup.sh first."
    exit 1
fi

# 1. Inject Python module lookup context directly into the environment shell
export PYTHONPATH=src

# 2. Activate the isolated workspace dependencies
source venv/bin/activate

# 3. Fire the test runner execution engine
robot --variable ENV:${TARGET_ENV} --outputdir test-results/ tests/restful_booker_bdd.robot

# 4. Gracefully release the terminal back to normal state configurations
deactivate
