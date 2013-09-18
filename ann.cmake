#
# Install ann from source
#

if (NOT ann_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (python)

external_source (ann
    1.1.2
    ann_1.1.2.tar.gz
    7ffaacc7ea79ca39d4958a6378071365
    http://www.cs.umd.edu/~mount/ANN/Files/1.1.2
    FORCE)

if(${ILASTIK_BITNESS} STREQUAL "32")
    set(ANN_BITNESS "Win32")
    set (ann_PATCH echo)
else()
    set(ANN_BITNESS "x64")
    # patch to support x64 build platform
    set (ann_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_ann.py ${ann_SRC_DIR})
endif()

# install script
SET(ann_BUILD_DIR ${ann_SRC_DIR}/MS_Win32)
SET(ann_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/ann_install.cmake)
FILE(WRITE   ${ann_INSTALL} "file(INSTALL bin/ANN.dll DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${ann_INSTALL} "file(INSTALL dll/Release/ANN.lib DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")
FILE(APPEND  ${ann_INSTALL} "file(INSTALL ${ann_SRC_DIR}/include/ANN DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include)\n")

        
message ("Installing ${ann_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${ann_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${ann_URL}
    URL_MD5             ${ann_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       devenv MS_WIN32\\Ann.sln /upgrade
    CONFIGURE_COMMAND   ${ann_PATCH}
    BINARY_DIR          ${ann_SRC_DIR}/MS_Win32
    BUILD_COMMAND       devenv Ann.sln /build "Release|${ANN_BITNESS}" /project dll
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${ann_INSTALL}
)

set_target_properties(${ann_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ann_NAME)
