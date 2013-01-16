#
# Install python from source
#
# Defines the following:
#    PYTHON_INCLUDE_PATH
#    PYTHON_EXE -- path to python executable

if (NOT python_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

# include (zlib)
#include (openssl)   # without openssl, hashlib might have missing encryption methods

external_source (python
    2.7.3
    Python-2.7.3.tgz
    2cf641732ac23b18d139be077bd906cd
    http://www.python.org/ftp/python/2.7.3
    FORCE)

SET(PYTHON_PREFIX ${ILASTIK_DEPENDENCY_DIR}/python)
SET(PYTHON_BIN_DIR ${python_SRC_DIR}/PCbuild)

# Add missing '/MANIFEST' compiler flag to msvc9compiler.py
set(python_PATCH amd64\\python.exe ${PROJECT_SOURCE_DIR}/patches/patch_python.py ../Lib/distutils/msvc9compiler.py)

SET(python_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/python_install.cmake)
FILE(WRITE   ${python_INSTALL} "file(INSTALL amd64/python.exe amd64/python27.dll DESTINATION ${PYTHON_PREFIX})\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ../Include/ ../PC/pyconfig.h DESTINATION ${PYTHON_PREFIX}/include)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL amd64/ DESTINATION ${PYTHON_PREFIX}/DLLs FILES_MATCHING PATTERN *.pyd)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL amd64/ DESTINATION ${PYTHON_PREFIX}/libs FILES_MATCHING PATTERN *.lib)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ../Lib DESTINATION ${PYTHON_PREFIX})\n")

message ("Installing ${python_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${python_NAME}
    DEPENDS             # ${zlib_NAME} ${openssl_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    BINARY_DIR          ${PYTHON_BIN_DIR}
    CONFIGURE_COMMAND   devenv PCbuild.sln /upgrade
    BUILD_COMMAND       devenv PCbuild.sln /build Release|x64 /project Python
                        \ndevenv PCbuild.sln /build Release|x64 /project _ctypes
                        \ndevenv PCbuild.sln /build Release|x64 /project _elementtree
                        \ndevenv PCbuild.sln /build Release|x64 /project _multiprocessing
                        \ndevenv PCbuild.sln /build Release|x64 /project _socket
                        \ndevenv PCbuild.sln /build Release|x64 /project select
                        \ndevenv PCbuild.sln /build Release|x64 /project unicodedata
                        \n ${python_PATCH}
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${python_INSTALL}
)

set (PYTHON_INCLUDE_PATH ${PYTHON_PREFIX}/include)
set (PYTHON_LIBRARY_FILE ${PYTHON_PREFIX}/libs/python27.lib)
set (PYTHON_EXE ${PYTHON_PREFIX}/python.exe)

set_target_properties(${python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_NAME)
