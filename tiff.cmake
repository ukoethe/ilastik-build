#
# Install tiff from source
#

if (NOT tiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (tiff
    4.0.1
    tiff-4.0.1.tar.gz
    fae149cc9da35c598d8be897826dfc63
    http://download.osgeo.org/libtiff
    FORCE)

set (tiff_PATCH python ${PROJECT_SOURCE_DIR}/patches/tiff.py ${tiff_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})
        
message ("Installing ${tiff_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${tiff_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${tiff_URL}
    URL_MD5             ${tiff_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${tiff_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       nmake /f Makefile.vc
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${ILASTIK_DEPENDENCY_DIR}/src/${tiff_NAME}/cmake-install.cmake
)

set_target_properties(${tiff_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT tiff_NAME)