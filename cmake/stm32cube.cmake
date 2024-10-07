# ********************************************************************
# _       _         _
# _ __ | |_  _ | |  __ _ | |__   ___
# | '__|| __|(_)| | / _` || '_ \ / __|
# | |   | |_  _ | || (_| || |_) |\__ \
# |_|    \__|(_)|_| \__,_||_.__/ |___/
#
# www.rt-labs.com
# Copyright 2021 rt-labs AB, Sweden.
#
# This software is licensed under the terms of the BSD 3-clause
# license. See the file LICENSE distributed with this software for
# full license information.
# *******************************************************************/

#[=======================================================================[.rst:
STM32Cube toolchain
-------------------

The following environment variables must be set when cmake
configuration is invoked::

  CPU           - Name of CPU
  BOARD         - Name of board
  CUBE_DIR      - Path to STM32Cube firmware

Machine-specific flags will be loaded from toolchain/${CPU}.cmake. See
the toolchain folder for known values.

Your CMAKE_MODULE_PATH must also be configured so that
Platform/STM32Cube.cmake can be found.
#]=======================================================================]

include_guard()

# The name of the target operating system
set(CMAKE_SYSTEM_NAME STM32Cube)

set(CPU $ENV{CPU} CACHE STRING "")
set(BOARD $ENV{BOARD} CACHE STRING "")
set(CUBE_DIR $ENV{CUBE_DIR} CACHE STRING "")

# Set cross-compiler toolchain
set(CMAKE_C_COMPILER /usr/bin/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER ${CMAKE_C_COMPILER})
set(OBJCOPY arm-none-eabi-objcopy)

if(CMAKE_HOST_WIN32)
  set(CMAKE_C_COMPILER ${CMAKE_C_COMPILER}.exe)
  set(CMAKE_CXX_COMPILER ${CMAKE_CXX_COMPILER}.exe)
  set(OBJCOPY ${OBJCOPY}.exe)
endif(CMAKE_HOST_WIN32)

# Set cross-compiler machine-specific flags
include(toolchain/${CPU})

add_library(iolmaster_osal)
set(IOLMASTER_COMMON_SOURCES
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/stm/osal_irq.c
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/stm/osal_spi.c
)

target_sources(iolmaster_osal
  PRIVATE
  ${IOLMASTER_COMMON_SOURCES}
)

target_include_directories(iolmaster_osal
  PUBLIC
  $<BUILD_INTERFACE:${IOLINKMASTER_BINARY_DIR}/include>
  $<BUILD_INTERFACE:${IOLINKMASTER_SOURCE_DIR}/iol_osal/include>
  $<INSTALL_INTERFACE:include>
  PRIVATE
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/stm
  ${IOLINKMASTER_FTDI_DRIVER_PREFIX}/include
)

target_link_libraries(iolmaster_osal
  PRIVATE
  osal
)

set(GOOGLE_TEST_INDIVIDUAL TRUE)