#
# Install hdf5 library from source
#

if (NOT hdf5_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (zlib)

external_source (hdf5
    1.8.10
    hdf5-1.8.10.tar.gz
    710aa9fb61a51d61a7e2c09bf0052157
    http://www.hdfgroup.org/ftp/HDF5/current/src
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
        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR}
        -DHDF5_BUILD_HL_LIB=ON
        -DBUILD_SHARED_LIBS=ON
        -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
        -DZLIB_DIR=${ILASTIK_DEPENDENCY_DIR}
        -DZLIB_INCLUDE_DIR=${ILASTIK_DEPENDENCY_DIR}/include
        -DZLIB_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/zlib.lib
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       devenv HDF5.sln /build Release /project hdf5 /project hdf5_hl
    INSTALL_COMMAND     devenv HDF5.sln /build Release /project INSTALL
)

set_target_properties(${hdf5_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT hdf5_NAME)