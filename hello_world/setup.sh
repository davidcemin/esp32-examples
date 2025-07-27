#!/bin/bash

# === Configuration ===
ESP_IDF_PATH="$HOME/proj/esp/esp-idf"
VENV_PATH="$HOME/.espressif/python_env/idf6.0_py3.12_env"
PYTHON_PATH="$VENV_PATH/bin/python"
VS_CODE_BIN="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

echo "🔧 Activating ESP-IDF environment using Python 3.12"

# Step 1: Check if venv exists
if [ ! -x "$PYTHON_PATH" ]; then
  echo "❌ Python virtual environment not found at: $PYTHON_PATH"
  echo "Please make sure it's installed correctly."
  exit 1
fi

# Step 2: Export the environment
export IDF_PYTHON_ENV_PATH="$VENV_PATH"
source "$ESP_IDF_PATH/export.sh"

# Step 3: Run diagnostics
echo "🩺 Running idf.py doctor..."
idf.py doctor

# Step 4: Optionally launch VSCode
if command -v code >/dev/null 2>&1; then
  echo "🚀 Launching VSCode..."
  code .
else
  echo "⚠️ VSCode 'code' CLI not found. You can open it manually if needed."
  echo "To enable it, open VSCode → Command Palette → 'Shell Command: Install 'code' command in PATH'"
fi

