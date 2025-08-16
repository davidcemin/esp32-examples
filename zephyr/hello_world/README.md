# Zephyr + ESP32-S3 Hello World

This project shows how to **build and flash** a Zephyr RTOS app onto an **ESP32-S3 DevKitM** using a plain CMake workflow (no `west build`). We only use `west` for flashing/monitoring.

---

## Prerequisites

- Zephyr workspace already set up (your `ZEPHYR_BASE` points to the Zephyr repo).
- ESP-IDF installed & sourced; Espressif toolchain installed (e.g. via `install.sh esp32s3`).
- Zephyr Python venv with Zephyr’s requirements installed.
- Your environment script (e.g. `~/proj/zephyr/zephyr-env/zephyr_env.sh`) is working.

Verify:
```bash
source ~/proj/zephyr/zephyr-env/zephyr_env.sh
zstatus
```

You should see `ESP-IDF sourced: 1`, the Xtensa toolchain, and your Zephyr base path.

---

## Project Layout

```
hello_world/
├─ CMakeLists.txt        # sets BOARD + toolchain + Python for Zephyr
├─ prj.conf
└─ src/
   └─ main.c
```

Your `CMakeLists.txt` is preconfigured with:
- `BOARD = esp32s3_devkitm/esp32s3/procpu`
- `ZEPHYR_TOOLCHAIN_VARIANT = espressif`
- `Python3_EXECUTABLE = ~/.zephyr-venv/bin/python3`

So you don’t need to pass these on the CLI.

---

## Build

From the project root:

```bash
mkdir -p build
cd build
cmake ..                  # uses the settings baked into CMakeLists.txt
make -j                   # or: ninja
```

Artifacts will appear under:
```
build/zephyr/zephyr.elf
build/zephyr/zephyr.bin
```

---

## Flash

Connect the board and find your port (macOS example):
```bash
ls /dev/tty.usb*
# e.g. /dev/tty.usbserial-140
```

Flash (from **inside `build/`**):
```bash
west flash -d . -r esp32 --skip-rebuild -- --esp-device /dev/tty.usbserial-140
```

What this does:
- Uses the **`esp32`** runner (UART via esptool)
- Points west at the current build dir (`-d .`)
- Sets your serial port once with `--esp-device ...`

> If you see a port-open error, hold **BOOT**, tap **EN** (reset), release **BOOT**, then retry.

---

## Monitor Serial Output

Pick one:

```bash
# West's monitor (Espressif)
west espressif monitor --esp-device /dev/tty.usbserial-140

# Or IDF's monitor
idf.py -p /dev/tty.usbserial-140 monitor

# Or plain Python
python -m serial.tools.miniterm /dev/tty.usbserial-140 115200
```

---

## Clean Rebuild

```bash
rm -rf build
mkdir build && cd build
cmake ..
make -j
```

---

## Tips

- To avoid retyping the port every time, you can cache it when configuring:
  ```bash
  cmake .. -DWEST_FLASH_EXTRA_ARGS="--esp-device /dev/tty.usbserial-140"
  make -j
  make flash
  ```
- Check supported runners for this build:
  ```bash
  west runners -d .
  ```
  You should see `esp32` (flash) and `openocd` (debug).

---

✅ That’s it. Build with **CMake/Make**, flash with **`west -r esp32`**, and monitor over serial.
