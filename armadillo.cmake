#
# Install armadillo from source
#

if (NOT armadillo_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (openblas)

external_source (armadillo
    4.0.4
    armadillo-4.000.4.tar.gz
    c548089e29ee69e9a6e9bce76d270bea
    http://sourceforge.net/projects/arma/files
    FORCE)
    
if(${ILASTIK_BITNESS} STREQUAL "64")
    set(ARMA_USE_64BIT_WORD "-DARMA_64BIT_WORD=1")
endif()
    
message ("Installing ${armadillo_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${armadillo_NAME}
    DEPENDS             ${openblas_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${armadillo_URL}
    URL_MD5             ${armadillo_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/armadillo.patch
    LIST_SEPARATOR ^^
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${armadillo_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR}
        -DOpenBLAS_NAMES=libopenblas
        -DCMAKE_MODULE_PATH=${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5/
        ${ARMA_USE_64BIT_WORD}
    BUILD_COMMAND       devenv armadillo.sln /build Release /project ALL_BUILD
    INSTALL_COMMAND     devenv armadillo.sln /build Release /project INSTALL
)

set_target_properties(${armadillo_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT armadillo_NAME)
