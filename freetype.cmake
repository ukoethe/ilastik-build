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
    http://download-mirror.savannah.gnu.org/releases/freetype/
    FORCE)

if(${ILASTIK_BITNESS} STREQUAL "32")
    set(FREETYPE_BITNESS "Win32")
    set (freetype_PATCH echo)
else()
    set(FREETYPE_BITNESS "x64")
    set (freetype_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_freetype.py ${freetype_BIN_DIR})
endif()


set(freetype_BIN_DIR  ${freetype_SRC_DIR}/builds/win32/vc2010)

# Switch to x64 build (FIXME: the RE is very siplistic -- check)

message ("Installing ${freetype_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${freetype_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${freetype_URL}
    URL_MD5             ${freetype_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${freetype_PATCH}
    CONFIGURE_COMMAND   devenv freetype.sln /upgrade
    BINARY_DIR          ${freetype_BIN_DIR}
    BUILD_COMMAND       devenv freetype.sln /build "Release Multithreaded|${FREETYPE_BITNESS}" /project freetype
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy_directory ../../../include ${ILASTIK_DEPENDENCY_DIR}/include
                      \n ${CMAKE_COMMAND} -E copy ../../../objs/win32/vc2010/freetype2411MT.lib ${ILASTIK_DEPENDENCY_DIR}/lib/freetype.lib
)

set_target_properties(${freetype_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT freetype_NAME)
