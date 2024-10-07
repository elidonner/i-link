add_library(iolmaster_osal)

set(IOLMASTER_COMMON_SOURCES
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/stm32/osal_irq.c
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/linux/osal_spi.c
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
  ${IOLINKMASTER_SOURCE_DIR}/iol_osal/stm32
  ${IOLINKMASTER_FTDI_DRIVER_PREFIX}/include
)

target_link_libraries(iolmaster_osal
  PRIVATE
  osal
)
set(GOOGLE_TEST_INDIVIDUAL TRUE)