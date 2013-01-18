#
# Install freetype from source
#

if (NOT freetype_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (freetype
    2.4.11
    freetype-2.4.11.tar.gz
    5af8234cf36f64dc2b97f44f89325117
    http://download.savannah.gnu.org/releases/freetype/
    FORCE)


set(freetype_BIN_DIR  ${freetype_SRC_DIR}/builds/win32/vc2010)

# Switch to x64 build (FIXME: the RE is very siplistic -- check)
set (freetype_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_freetype.py ${freetype_BIN_DIR})

SET(freetype_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/freetype_install.cmake)
FILE(WRITE   ${freetype_INSTALL} "file(INSTALL ../../../include/ DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include)\n")
FILE(APPEND  ${freetype_INSTALL} "file(INSTALL ../../../objs/win32/vc2010/ DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib FILES_MATCHING PATTERN *MT.lib)\n")

message ("Installing ${freetype_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${freetype_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${freetype_URL}
    URL_MD5             ${freetype_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${freetype_PATCH}
    CONFIGURE_COMMAND   ""
    BINARY_DIR          ${freetype_BIN_DIR}
    BUILD_COMMAND       devenv freetype.sln /build "Release Multithreaded|x64" /project freetype
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${freetype_INSTALL}
)

set_target_properties(${freetype_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT freetype_NAME)