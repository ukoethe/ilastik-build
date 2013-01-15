#
# Install fftw from source
#

if (NOT fftw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (python)

external_source (fftw
    3.3.3
    fftw-3.3.3.tar.gz
    0a05ca9c7b3bfddc8278e7c40791a1c2
    http://www.fftw.org
    FORCE)

set (fftw_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/fftw.py ${fftw_SRC_DIR})

SET(fftw_BUILD_DIR ${fftw_SRC_DIR}/fftw-3.3-libs)
SET(fftw_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/fftw_install.cmake)
FILE(WRITE   ${fftw_INSTALL} "file(INSTALL ../api/fftw3.h DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include)\n")
FILE(APPEND  ${fftw_INSTALL} "file(GLOB fftw_DLL ${fftw_BUILD_DIR}/x64/Release/*.dll)\n")
FILE(APPEND  ${fftw_INSTALL} "file(INSTALL \${fftw_DLL} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${fftw_INSTALL} "file(GLOB fftw_LIB ${fftw_BUILD_DIR}/x64/Release/*.lib)\n")
FILE(APPEND  ${fftw_INSTALL} "file(INSTALL \${fftw_LIB} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")
        
message ("Installing ${fftw_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${fftw_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${fftw_URL}
    URL_MD5             ${fftw_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${fftw_PATCH}
    CONFIGURE_COMMAND   ""
    BINARY_DIR          ${fftw_SRC_DIR}/fftw-3.3-libs
    BUILD_COMMAND       devenv fftw-3.3-libs.sln /build Release /project libfftw-3.3
                      \ndevenv fftw-3.3-libs.sln /build Release /project libfftwf-3.3
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${fftw_INSTALL}
)

set_target_properties(${fftw_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT fftw_NAME)