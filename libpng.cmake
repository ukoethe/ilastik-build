#
# Install libpng from source
#

if (NOT libpng_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (libpng
    1.5.13
    libpng-1.5.13.tar.gz
    9c5a584d4eb5fe40d0f1bc2090112c65
    http://downloads.sourceforge.net/project/libpng/libpng15/1.5.13
    FORCE)

message ("Installing ${libpng_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${libpng_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${libpng_URL}
    URL_MD5             ${libpng_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${libpng_SRC_DIR} 
         -G ${CMAKE_GENERATOR} 
         -DZLIB_INCLUDE_DIR=${ILASTIK_DEPENDENCY_DIR}/include
         -DZLIB_LIBRARY=${ILASTIK_DEPENDENCY_DIR}/lib/zlib.lib
         -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       devenv libpng.sln /build Release /project png15
    INSTALL_COMMAND     devenv libpng.sln /build Release /project INSTALL
)

set_target_properties(${libpng_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libpng_NAME)