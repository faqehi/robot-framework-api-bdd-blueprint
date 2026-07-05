#!/bin/bash
set -e # Exit immediately if any command returns a non-zero status code

echo "=============================================================================="
echo "🚀 Initializing UNIX Robot Framework Workspace Environment..."
echo "=============================================================================="

# Verify Python 3 presence in the runner environment
if ! command -v python3 &> /dev/null; then
    echo "❌ Fatal: Python 3 interpreter could not be resolved by system execution context."
    exit 1
fi

# Validate dependency locking blueprint exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ Fatal: requirements.txt configuration blueprint is missing from root directory."
    exit 1
fi

# Form the isolated virtual environment folder structure
echo "📂 Provisioning clean virtual environment [venv]..."
python3 -m venv venv

# Activate venv scope, update package engines, and deploy requirements
echo "📦 Syncing workspace packages..."
source venv/bin/activate
python3 -m pip install --upgrade pip
pip install -r requirements.txt

echo "=============================================================================="
echo "✅ Workspace verification complete! Execute './run_tests.sh' to verify the suite."
echo "=============================================================================="
