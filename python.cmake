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

include (zlib)
#include (openssl)   # without openssl, hashlib might have missing encryption methods

external_source (python
    2.7.3
    Python-2.7.3.tgz
    2cf641732ac23b18d139be077bd906cd
    http://www.python.org/ftp/python/2.7.3
    FORCE)

SET(python_BUILD ${ILASTIK_DEPENDENCY_DIR}/tmp/python_build.cmake)
FILE(WRITE   ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project Python)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project _ctypes)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project _elementtree)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project _multiprocessing)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project _socket)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project select)\n")
FILE(APPEND  ${python_BUILD} "execute_process(COMMAND devenv PCbuild.sln /build Release|x64 /project unicodedata)\n")
FILE(APPEND  ${python_BUILD} "file(MAKE_DIRECTORY ${python_SRC_DIR}/DLLs)\n")
FILE(APPEND  ${python_BUILD} "file(GLOB pydll amd64/*.dll)\n")
FILE(APPEND  ${python_BUILD} "file(GLOB pymodule amd64/*.pyd)\n")
FILE(APPEND  ${python_BUILD} "file(INSTALL DESTINATION ${python_SRC_DIR}/DLLs TYPE FILE FILES \${pydll} \${pymodule})\n")

message ("Installing ${python_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${python_NAME}
    DEPENDS             ${zlib_NAME} # ${openssl_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       devenv PCbuild/PCbuild.sln /upgrade 
    BINARY_DIR          ${python_SRC_DIR}/PCbuild
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${CMAKE_COMMAND} -P ${python_BUILD}
    INSTALL_COMMAND     ""
)

set (PYTHON_BOOTSTRAP_EXE ${python_SRC_DIR}/PCbuild/amd64/python.exe)

set_target_properties(${python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_NAME)
