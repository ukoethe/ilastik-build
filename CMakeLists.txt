CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
project (ilastik)

include (ExternalProject)

############################################################################
# Check if BUILDEM_DIR has already been assigned.  If not, create a default.
set (ILASTIK_DEPENDENCY_DIR "None" CACHE TYPE STRING)

if (${ILASTIK_DEPENDENCY_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: ILASTIK_DEPENDENCY_DIR build directory (for all downloads & builds) should be specified via -DILASTIK_DEPENDENCY_DIR=<path> on cmake command line.")
endif ()

message ("ilastik downloads and builds will be placed here: ${ILASTIK_DEPENDENCY_DIR}")

############################################################################

SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  ${ilastik_SOURCE_DIR})

ADD_CUSTOM_TARGET(ilastik)
include(zlib)
include(jpeg)
include(tiff)
include(libpng)
include(fftw)
include(hdf5)
include(boost)

ADD_DEPENDENCIES(ilastik ${zlib_NAME})
ADD_DEPENDENCIES(ilastik ${jpeg_NAME})
ADD_DEPENDENCIES(ilastik ${tiff_NAME})
ADD_DEPENDENCIES(ilastik ${libpng_NAME})
ADD_DEPENDENCIES(ilastik ${fftw_NAME})
ADD_DEPENDENCIES(ilastik ${hdf5_NAME})
ADD_DEPENDENCIES(ilastik ${boost_NAME})
