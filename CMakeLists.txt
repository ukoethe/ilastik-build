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

FILE(MAKE_DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/bin 
                    ${ILASTIK_DEPENDENCY_DIR}/lib 
                    ${ILASTIK_DEPENDENCY_DIR}/include
                    ${ILASTIK_DEPENDENCY_DIR}/tmp )

############################################################################

SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  ${ilastik_SOURCE_DIR})

ADD_CUSTOM_TARGET(ilastik)
include(python)
include(python_packages)
# include(numpy)
include(zlib)
include(jpeg)
include(tiff)
include(libpng)
include(fftw)
include(hdf5)
include(h5py)
include(boost)
include(vigra)
include(qt)
# include(pyqt)

ADD_DEPENDENCIES(ilastik 
        ${python_NAME}
        ${python_packages_NAME}
        # ${numpy_NAME}
        ${zlib_NAME}
        ${jpeg_NAME}
        ${tiff_NAME}
        ${libpng_NAME}
        ${fftw_NAME}
        ${hdf5_NAME}
        ${h5py_NAME}
        ${boost_NAME}
        ${vigra_NAME}
        ${qt_NAME}
        # ${pyqt_NAME}
)
