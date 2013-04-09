#
# Install boost libraries from source
#

if (NOT boost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
# include (zlib)

set (boost_INCLUDE_DIR  ${ILASTIK_DEPENDENCY_DIR}/include/boost)

external_source (boost
    1.51.0
    boost_1_51_0.tar.gz
    6a1f32d902203ac70fbec78af95b3cf8
    http://downloads.sourceforge.net/project/boost/boost/1.51.0
    FORCE)
    
string(REGEX REPLACE "bin/.*" "vcvarsall.bat" VCVARSALL_BAT "${CMAKE_C_COMPILER}")
file(TO_NATIVE_PATH ${VCVARSALL_BAT} VCVARSALL_BAT)

FILE(WRITE ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam "using python : : ${PYTHON_EXE} ;\n")
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam boost_PATCH)

SET(boost_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_install.cmake)
FILE(WRITE   ${boost_INSTALL} "file(INSTALL boost/ DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include/boost)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_PYTHON_BUILD_DIR ${boost_SRC_DIR}/bin.v2/libs/python/build/msvc-*/release/address-model-64/threading-multi)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_DLL \${boost_PYTHON_BUILD_DIR}/boost*.dll)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_DLL} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_LIB \${boost_PYTHON_BUILD_DIR}/boost*.lib)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_LIB} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")

message ("Installing ${boost_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${boost_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${boost_URL}
    URL_MD5             ${boost_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   call "${VCVARSALL_BAT}" x86   # bootstrap.bat needs the 32-bit compiler
                        \ncall bootstrap.bat 
                        \nmore ${boost_PATCH} >> project-config.jam
    BUILD_COMMAND       ./b2 --with-python --with-serialization variant=release threading=multi link=shared toolset=msvc address-model=64
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${boost_INSTALL}
)

set_target_properties(${boost_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT boost_NAME)
