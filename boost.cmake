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
FILE(APPEND ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam "using msvc : ${VISUAL_STUDIO_VERSION}.0 ;\n")
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/boost_patch.jam boost_PATCH)

message("Installing ${boost_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
message(STATUS "${boost_NAME} environment for bootstrapping: ${VCVARSALL_BAT}")

## generate toolset string
set(BOOST_TOOLSET "msvc-${VISUAL_STUDIO_VERSION}.0")
message(STATUS "${boost_NAME} toolset: ${BOOST_TOOLSET}")

set(BOOST_OPTIONS --layout=system --with-python --with-serialization --with-system --with-filesystem --with-test --with-timer variant=release threading=multi link=shared toolset=${BOOST_TOOLSET} address-model=${ILASTIK_BITNESS})

ExternalProject_Add(${boost_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${boost_URL}
    URL_MD5             ${boost_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   call "${VCVARSALL_BAT}" x86   # bootstrap.bat needs the 32-bit compiler
                        \nset CC=cl.exe               # bootstrap.bat cannot handle spaces in paths
                        \ncall bootstrap.bat vc${VISUAL_STUDIO_VERSION}
                        \nmore ${boost_PATCH} >> project-config.jam
    BUILD_COMMAND       ./b2 ${BOOST_OPTIONS}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ./b2 --prefix=${ILASTIK_DEPENDENCY_DIR} ${BOOST_OPTIONS} install
                        \nmove ${ILASTIK_DEPENDENCY_DIR_DOS}\\lib\\boost*.dll ${ILASTIK_DEPENDENCY_DIR_DOS}\\bin
)

set_target_properties(${boost_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT boost_NAME)
