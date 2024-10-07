add_library(iolmaster_osal)

# TODO: ett snyggare sätt att bygga beroende på linux/linux-usb
set(IOLMASTER_USB_SOURCES
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_spi_usb_helpers.c
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_irq_usb.c
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_spi_usb.c
)

set(IOLMASTER_COMMON_SOURCES
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_irq.c
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_spi.c
)

option(IOLINKMASTER_USB_MODE_ENABLE "Enable usb mode" OFF)

if(IOLINKMASTER_USB_MODE_ENABLE)
  add_definitions(-DIOLINKMASTER_USB_MODE_ENABLE)

  if(NOT IOLINKMASTER_FTDI_DRIVER_PREFIX)
    find_path(IOLINKMASTER_FTDI_DRIVER_PREFIX include/ftd2xx.h PATHS /usr/local)
  endif()

  target_sources(iolmaster_osal
    PRIVATE
    ${IOLMASTER_USB_SOURCES}
  )

  target_include_directories(iolmaster_osal
    PUBLIC
    $<BUILD_INTERFACE:${IOLINKMASTER_BINARY_DIR}/include>
    $<BUILD_INTERFACE:${IOLINKMASTER_SOURCE_DIR}/iol_osal/include>
    $<INSTALL_INTERFACE:include>
    PRIVATE
    ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux
    ${IOLINKMASTER_FTDI_DRIVER_PREFIX}/include
  )

  target_link_libraries(iolmaster_osal
    PRIVATE
    osal
    ${IOLINKMASTER_FTDI_DRIVER_PREFIX}/lib/libftd2xx.so
  )
else()
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
    ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux
    ${IOLINKMASTER_FTDI_DRIVER_PREFIX}/include
  )

  target_link_libraries(iolmaster_osal
    PRIVATE
    osal
  )
endif(IOLINKMASTER_USB_MODE_ENABLE)

set(GOOGLE_TEST_INDIVIDUAL TRUE)