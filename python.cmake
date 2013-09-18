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

include (bzip2)

# include (zlib)
include (nasm)
include (openssl)

external_source (python
    2.7.3
    Python-2.7.3.tgz
    2cf641732ac23b18d139be077bd906cd
    http://www.python.org/ftp/python/2.7.3
    FORCE)

SET(PYTHON_PREFIX ${ILASTIK_DEPENDENCY_DIR}/python)
SET(PYTHON_BIN_DIR ${python_SRC_DIR}/PCbuild)

if(${ILASTIK_BITNESS} STREQUAL "32")
    set(PYTHON_BITNESS "Win32")
    set(PYTHON_PATH_PREFIX ".")
else()
    set(PYTHON_BITNESS "x64")
    set(PYTHON_PATH_PREFIX "amd64")
endif()


# Add missing '/MANIFEST' compiler flag to msvc9compiler.py
set(python_PATCH ${PYTHON_PATH_PREFIX}\\python.exe ${PROJECT_SOURCE_DIR}/patches/patch_python.py ../Lib/distutils/msvc9compiler.py ../Lib/distutils/cygwinccompiler.py)

SET(python_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/python_install.cmake)
FILE(WRITE   ${python_INSTALL} "file(INSTALL ${PYTHON_PATH_PREFIX}/python.exe ${PYTHON_PATH_PREFIX}/python27.dll DESTINATION ${PYTHON_PREFIX})\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ../Include/ ../PC/pyconfig.h DESTINATION ${PYTHON_PREFIX}/include)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ${PYTHON_PATH_PREFIX}/ DESTINATION ${PYTHON_PREFIX}/DLLs FILES_MATCHING PATTERN *.pyd)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ${PYTHON_PATH_PREFIX}/ DESTINATION ${PYTHON_PREFIX}/libs FILES_MATCHING PATTERN *.lib)\n")
FILE(APPEND  ${python_INSTALL} "file(INSTALL ../Lib DESTINATION ${PYTHON_PREFIX})\n")

message ("Installing ${python_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${python_NAME}
    DEPENDS             ${bzip2_NAME} ${openssl_NAME} ${nasm_NAME} # ${zlib_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    BINARY_DIR          ${PYTHON_BIN_DIR}
    CONFIGURE_COMMAND   devenv PCbuild.sln /upgrade
    BUILD_COMMAND       ${ADD_PATH} "${PERL_PATH}" "${nasm_PATH}"
                        \nset HOST_PYTHON=${PYTHON_PATH_PREFIX}/python.exe
                        \nperl -p -i.bak -e s/openssl-0.9.8l/${openssl_NAME}/g pyproject.props
                        \n ${PATCH_EXE} -i ${PROJECT_SOURCE_DIR}/patches/build_ssl.py.patch
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project Python
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project _ctypes
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project _elementtree
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project _multiprocessing
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project _socket
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project pyexpat
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project select
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project unicodedata
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project bz2
                        \ndevenv PCbuild.sln /build "Release|${PYTHON_BITNESS}" /project _ssl
                        \n ${python_PATCH}
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${python_INSTALL}
)

set (PYTHON_INCLUDE_PATH ${PYTHON_PREFIX}/include)
set (PYTHON_LIBRARY_FILE ${PYTHON_PREFIX}/libs/python27.lib)
set (PYTHON_EXE ${PYTHON_PREFIX}/python.exe)

set_target_properties(${python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_NAME)
