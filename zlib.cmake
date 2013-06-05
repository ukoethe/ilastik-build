#
# Install zlib from source
#

if (NOT zlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (python)

external_source (zlib
    1.2.8
    zlib-1.2.8.tar.gz
    44d667c142d7cda120332623eab69f40
    http://zlib.net
    FORCE)

# Workaround for cmake bug (missing "/machine:x64" compiler flag)
set (zlib_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_zlib.py ${zlib_SRC_DIR})
        
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