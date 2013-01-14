#
# Install boost libraries from source
#

if (NOT boost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

# include (python)
# include (zlib)

set (boost_INCLUDE_DIR  ${ILASTIK_DEPENDENCY_DIR}/include/boost)
include_directories (${boost_INCLUDE_DIR})

external_source (boost
    1.51.0
    boost_1_51_0.tar.gz
    6a1f32d902203ac70fbec78af95b3cf8
    http://downloads.sourceforge.net/project/boost/boost/1.51.0
    FORCE)

# Add layout=tagged param to first boost install to explicitly create -mt libraries
# some libraries require.  TODO: Possibly shore up all library find paths to only
# allow use of built libs.
message ("Installing ${boost_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${boost_NAME}
    # DEPENDS             ${zlib_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${boost_URL}
    URL_MD5             ${boost_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ./bootstrap.bat
    BUILD_COMMAND       ./b2 --with-python --prefix=${ILASTIK_DEPENDENCY_DIR} --layout=system
         variant=release threading=multi link=shared toolset=msvc address-model=64 install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E rename 
        ${ILASTIK_DEPENDENCY_DIR}/lib/boost_python.dll ${ILASTIK_DEPENDENCY_DIR}/bin/boost_python.dll 
)

set_target_properties(${boost_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT boost_NAME)
