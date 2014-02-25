#
# Install mlpack from source
#

if (NOT mlpack_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include(armadillo)
include(libxml2)

external_source (mlpack
    1.0.8
    mlpack-1.0.8.tar.gz
    0331e12f2485b9d5d39c9d9dea618108
    http://www.mlpack.org/files
    FORCE)

message ("Installing ${mlpack_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${mlpack_NAME}
    DEPENDS             ${armadillo_NAME} ${libxml2_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${mlpack_URL}
    URL_MD5             ${mlpack_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/mlpack.patch
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${mlpack_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR}
        -DHDF5_DIR=${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5
        -DHDF5_C_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/hdf5dll.lib
        -DICONV_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/iconv.lib
        -DZLIB_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/zlib.lib
    BUILD_COMMAND       devenv mlpack.sln /build Release /project mlpack
    INSTALL_COMMAND     devenv mlpack.sln /build Release /project INSTALL
)

set_target_properties(${mlpack_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mlpack_NAME)
