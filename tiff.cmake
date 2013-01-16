#
# Install tiff from source
#

if (NOT tiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (python)

external_source (tiff
    4.0.1
    tiff-4.0.1.tar.gz
    fae149cc9da35c598d8be897826dfc63
    http://download.osgeo.org/libtiff
    FORCE)

# insert zlib and jpeg path into nmake.opt
set (tiff_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_tiff.py ${tiff_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

# create a CMake script for installation
SET(tiff_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/tiff_install.cmake)
FILE(WRITE   ${tiff_INSTALL} "file(INSTALL libtiff/tiff.h libtiff/tiffconf.h libtiff/tiffio.h libtiff/tiffiop.h libtiff/tiffvers.h DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include)\n")
FILE(APPEND  ${tiff_INSTALL} "file(INSTALL libtiff/libtiff.dll DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${tiff_INSTALL} "file(INSTALL libtiff/libtiff_i.lib libtiff/libtiff.lib DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")

        
message ("Installing ${tiff_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${tiff_NAME}
    DEPENDS             ${python_NAME} ${zlib_NAME} ${jpeg_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${tiff_URL}
    URL_MD5             ${tiff_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${tiff_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       nmake /f Makefile.vc
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${tiff_INSTALL}
)

set_target_properties(${tiff_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT tiff_NAME)