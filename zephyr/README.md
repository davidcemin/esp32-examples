# Zephyr + ESP-IDF Bring-up on macOS (ESP32-S3 Example)

This guide explains how to set up **Zephyr RTOS** with **ESP-IDF** support on macOS, targeting the **ESP32-S3 DevKitM** board.  
It also works for STM32 and other Zephyr-supported boards.

---

## 1. Create Workspace

```bash
mkdir -p ~/proj/zephyr/zephyr-env/workspace
cd ~/proj/zephyr/zephyr-env/workspace
```

---

## 2. Clone Zephyr + Modules

```bash
west init -m https://github.com/zephyrproject-rtos/zephyr zephyr
west update
```

---

## 3. Install Zephyr SDK

Download from [Zephyr SDK releases](https://github.com/zephyrproject-rtos/sdk-ng/releases) and install to:

```bash
~/zephyr-sdk
```

---

## 4. Install ESP-IDF

Clone the ESP-IDF repository:

```bash
mkdir -p ~/proj/esp
cd ~/proj/esp
git clone --recursive https://github.com/espressif/esp-idf.git
```

This guide assumes ESP-IDF is located at:

```
~/proj/esp/esp-idf
```

---

## 5. Create Python Virtual Environment

```bash
cd ~/proj/zephyr/zephyr-env
python3 -m venv .zephyr-venv
source .zephyr-venv/bin/activate
pip install --upgrade pip
pip install west
```

---

## 6. Environment Script (`zephyr_env.sh`)

Create `~/proj/zephyr/zephyr-env/zephyr_env.sh` with:

```bash
#!/usr/bin/env bash
# Zephyr + ESP-IDF environment setup script

# Paths
export ZEPHYR_WORKSPACE="$HOME/proj/zephyr/zephyr-env/workspace"
export ZEPHYR_BASE="$ZEPHYR_WORKSPACE/zephyr"
export ZEPHYR_SDK_INSTALL_DIR="$HOME/zephyr-sdk"
export IDF_PATH="$HOME/proj/esp/esp-idf"

# Activate Python venv
if [ -f "$HOME/proj/zephyr/zephyr-env/.zephyr-venv/bin/activate" ]; then
  source "$HOME/proj/zephyr/zephyr-env/.zephyr-venv/bin/activate"
fi

# Source ESP-IDF
if [ -f "$IDF_PATH/export.sh" ]; then
  source "$IDF_PATH/export.sh"
fi

# Find toolchain
TOOLBIN="$(command -v xtensa-esp32s3-elf-gcc || true)"
if [ -n "$TOOLBIN" ]; then
  export ESPRESSIF_TOOLCHAIN_PATH="$(dirname "$(dirname "$TOOLBIN")")"
fi

# Helper aliases
alias zwork="cd $ZEPHYR_WORKSPACE"
alias zstatus="env | egrep 'ZEPHYR|IDF|ESPRESSIF' | sort"

# Success message
echo "✅ Zephyr + ESP-IDF + Python environment ready."
echo "   Run 'zwork' to jump into workspace, 'zstatus' to check status."
```

Make it executable:

```bash
chmod +x ~/proj/zephyr/zephyr-env/zephyr_env.sh
```

---

## 7. Load Environment

```bash
source ~/proj/zephyr/zephyr-env/zephyr_env.sh
```

You should see:

```
✅ Zephyr + ESP-IDF + Python environment ready.
   Run 'zwork' to jump into workspace, 'zstatus' to check status.
```

---

## 8. Build Hello World (ESP32-S3)

```bash
zwork
west build -b esp32s3_devkitm/esp32s3/procpu $ZEPHYR_BASE/samples/hello_world --pristine   -DZEPHYR_TOOLCHAIN_VARIANT=espressif
```

---

## 9. Verify Post-Sourcing

Run:

```bash
zstatus
```

Expected output (example):

```
===== Zephyr Env =====
Python venv active:    1
ZEPHYR_BASE:           /Users/you/proj/zephyr/zephyr-env/workspace/zephyr
ZEPHYR_SDK_INSTALL_DIR /Users/you/zephyr-sdk
IDF_PATH:              /Users/you/proj/esp/esp-idf
ESPRESSIF_TOOLCHAIN_PATH: /Users/you/.espressif/tools/xtensa-esp-elf/esp-14.2.0_xxxxx/xtensa-esp-elf
ESP-IDF sourced:       1
=======================
```

---

## ✅ Done!

You now have a reproducible setup for **Zephyr RTOS + ESP-IDF** on macOS.  
Use the `zephyr_env.sh` script every time to set up your environment before building.
