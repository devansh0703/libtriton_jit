# ==============================================================================
# GCU (Enflame) Backend Configuration
# ==============================================================================

message(STATUS "Configuring GCU backend...")

set(TOPS_ROOT "/opt/tops" CACHE PATH "Enflame TOPS SDK root directory")

if(NOT EXISTS ${TOPS_ROOT}/include/tops_runtime_api.h)
  message(FATAL_ERROR "TOPS SDK not found at ${TOPS_ROOT}. "
    "Please set -DTOPS_ROOT to the correct TOPS SDK installation path.")
endif()

find_library(TOPSRT_LIBRARY
  NAMES topsrt
  PATHS ${TOPS_ROOT}/lib
  NO_DEFAULT_PATH
)

if(NOT TOPSRT_LIBRARY)
  message(FATAL_ERROR "libtopsrt.so not found in ${TOPS_ROOT}/lib")
endif()

if(NOT TARGET GCU::efrt)
  add_library(GCU::efrt SHARED IMPORTED)
  set_target_properties(GCU::efrt PROPERTIES
    IMPORTED_LOCATION "${TOPSRT_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${TOPS_ROOT}/include"
  )
endif()

function(target_link_gcu_libraries target_name)
  target_include_directories(${target_name} PUBLIC ${TOPS_ROOT}/include)
  target_link_libraries(${target_name} PUBLIC GCU::efrt)
endfunction()

message(STATUS "GCU backend configuration complete")
message(STATUS "  TOPS SDK: ${TOPS_ROOT}")
message(STATUS "  libtopsrt: ${TOPSRT_LIBRARY}")
