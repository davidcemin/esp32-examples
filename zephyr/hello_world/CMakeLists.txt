cmake_minimum_required(VERSION 3.20.0)

# Use JTAG for flashing/debugging (no serial port needed)
set(BOARD_FLASH_RUNNER openocd CACHE STRING "" FORCE)
set(BOARD_DEBUG_RUNNER openocd CACHE STRING "" FORCE)


# Force the board + toolchain (overrides any cached value)
set(BOARD "esp32s3_devkitm/esp32s3/procpu" CACHE STRING "Zephyr board target" FORCE)
set(ZEPHYR_TOOLCHAIN_VARIANT "espressif" CACHE STRING "Zephyr toolchain" FORCE)

# Make CMake/FindPython3 use your Zephyr venv Python (not ESP-IDF’s)
# IMPORTANT: variable name is Python3_EXECUTABLE (capital P).
set(Python3_EXECUTABLE "$ENV{HOME}/proj/zephyr/zephyr-env/.zephyr-venv/bin/python3"
    CACHE FILEPATH "Python 3 interpreter" FORCE)

# Locate Zephyr
if(NOT DEFINED ZEPHYR_BASE)
  if(DEFINED ENV{ZEPHYR_BASE})
    set(ZEPHYR_BASE $ENV{ZEPHYR_BASE})
  else()
    message(FATAL_ERROR "ZEPHYR_BASE not set. Source your zephyr_env.sh first.")
  endif()
endif()
find_package(Zephyr REQUIRED HINTS ${ZEPHYR_BASE})

project(hello_cmake)
target_sources(app PRIVATE src/main.c)

