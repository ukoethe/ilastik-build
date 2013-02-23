#
# Install hdf5 library from source
#

if (NOT hdf5_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (zlib)

# DO NOT USE HDF5 1.8.10 - it is buggy !
external_source (hdf5
    1.8.9
    hdf5-1.8.9.tar.gz
    d1266bb7416ef089400a15cc7c963218
    http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.9/src
    FORCE)

message ("Installing ${hdf5_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${hdf5_NAME}
    DEPENDS                 ${zlib_NAME}
    PREFIX                  ${ILASTIK_DEPENDENCY_DIR}
    URL                     ${hdf5_URL}
    URL_MD5                 ${hdf5_MD5}
    UPDATE_COMMAND          ""
    PATCH_COMMAND           ""
    CONFIGURE_COMMAND       ${CMAKE_COMMAND} ${hdf5_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DCMAKE_PREFIX_PATH:PATH=${ILASTIK_DEPENDENCY_DIR}
        -DHDF5_BUILD_HL_LIB:BOOL=ON
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON
        -DZLIB_INCLUDE_DIR:PATH=${ILASTIK_DEPENDENCY_DIR}/include
        -DZLIB_LIBRARY:FILEPATH=${ILASTIK_DEPENDENCY_DIR}/lib/zlib.lib
        -DCMAKE_INSTALL_PREFIX:PATH=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       devenv HDF5.sln /build Release /project hdf5
                      \ndevenv HDF5.sln /build Release /project hdf5_hl
    INSTALL_COMMAND     devenv HDF5.sln /build Release /project INSTALL
#                      \necho "ADD_DEFINITIONS(-DH5_BUILT_AS_DYNAMIC_LIB)" >> ${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5/hdf5-config.cmake
)

set_target_properties(${hdf5_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT hdf5_NAME)