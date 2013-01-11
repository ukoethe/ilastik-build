#
# Install fftw from source
#

if (NOT fftw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (fftw
    3.3.3
    fftw-3.3.3.tar.gz
    0a05ca9c7b3bfddc8278e7c40791a1c2
    http://www.fftw.org
    FORCE)

set (fftw_PATCH python ${PROJECT_SOURCE_DIR}/patches/fftw.py ${fftw_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})
        
message ("Installing ${fftw_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${fftw_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${fftw_URL}
    URL_MD5             ${fftw_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${fftw_PATCH}
    CONFIGURE_COMMAND   ""
    BINARY_DIR          ${fftw_SRC_DIR}/fftw-3.3-libs
    # on some strange reason, the following only builds libfftwf-3.3, although the same
    # mechanism works for many other packages
    # BUILD_COMMAND       devenv fftw-3.3-libs.sln /build Release /project libfftw-3.3 /project libfftwf-3.3
    BUILD_COMMAND       ${CMAKE_COMMAND} -P ${ILASTIK_DEPENDENCY_DIR}/src/${fftw_NAME}/cmake_build.cmake
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${ILASTIK_DEPENDENCY_DIR}/src/${fftw_NAME}/cmake_install.cmake
)

set_target_properties(${fftw_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT fftw_NAME)