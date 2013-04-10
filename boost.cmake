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
FILE(APPEND ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam "using msvc : 10.0 ;\n")
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam boost_PATCH)

message ("Installing ${boost_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
message("${boost_NAME} environment for bootstrapping: ${VCVARSALL_BAT}")

## generate install script
SET(boost_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_install.cmake)
FILE(WRITE   ${boost_INSTALL} "file(INSTALL boost/ DESTINATION ${ILASTIK_DEPENDENCY_DIR}/include/boost)\n")

# install boost-python
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_PYTHON_BUILD_DIR ${boost_SRC_DIR}/bin.v2/libs/python/build/msvc-*/release/address-model-64/threading-multi)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_PYTHON_DLL \${boost_PYTHON_BUILD_DIR}/boost*.dll)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_PYTHON_DLL} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_PYTHON_LIB \${boost_PYTHON_BUILD_DIR}/boost*.lib)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_PYTHON_LIB} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")

# install boost-serialization
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_SERIALIZATION_BUILD_DIR ${boost_SRC_DIR}/bin.v2/libs/serialization/build/msvc-*/release/address-model-64/threading-multi)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_SERIALIZATION_DLL \${boost_SERIALIZATION_BUILD_DIR}/boost*.dll)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_SERIALIZATION_DLL} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/bin)\n")
FILE(APPEND  ${boost_INSTALL} "file(GLOB boost_SERIALIZATION_LIB \${boost_SERIALIZATION_BUILD_DIR}/boost*.lib)\n")
FILE(APPEND  ${boost_INSTALL} "file(INSTALL \${boost_SERIALIZATION_LIB} DESTINATION ${ILASTIK_DEPENDENCY_DIR}/lib)\n")


## generate toolset string
set(BOOST_TOOLSET "msvc")
if(MSVC_VERSION)
  if(MSVC_VERSION EQUAL 1600)
    set(BOOST_TOOLSET "msvc-10.0")
  elseif(MSVC_VERSION EQUAL 1700)
    set(BOOST_TOOLSET "msvc-11.0")
  else()
    message(WARNING "${boost_NAME}: handling MSVC_VERSION ${MSVC_VERSION} not implemented; will use boost autodiscovery")
  endif()
else(MSVC_VERSION)
  message(WARNING "${boost_NAME}: MSVC_VERSION not defined; will use boost autodiscovery")
endif(MSVC_VERSION)
message("${boost_NAME} toolset: ${BOOST_TOOLSET}")

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
    BUILD_COMMAND       ./b2 --with-python --with-serialization variant=release threading=multi link=shared toolset=${BOOST_TOOLSET} address-model=64
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${boost_INSTALL}
)

set_target_properties(${boost_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT boost_NAME)
