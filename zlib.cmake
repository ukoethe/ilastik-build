#
# Install zlib from source
#

if (NOT zlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (python)

external_source (zlib
    1.2.7
    zlib-1.2.7.tar.gz
    60df6a37c56e7c1366cca812414f7b85
    http://zlib.net
    FORCE)

set (zlib_PATCH ${PYTHON_WIN_EXE} ${PROJECT_SOURCE_DIR}/patches/zlib.py ${zlib_SRC_DIR})
        
message ("Installing ${zlib_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${zlib_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${zlib_URL}
    URL_MD5             ${zlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${zlib_PATCH}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${zlib_SRC_DIR}
         -G ${CMAKE_GENERATOR} 
         -DBUILD_SHARED_LIBS=0
         -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       devenv zlib.sln /build Release /project zlib
    INSTALL_COMMAND     devenv zlib.sln /build Release /project INSTALL
)

set_target_properties(${zlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT zlib_NAME)