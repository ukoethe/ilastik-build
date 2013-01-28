#
# Install lemon from source
#

if (NOT lemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (lemon
    1.2.3
    lemon-1.2.3.tar.gz
    750251a77be450ddddedab14e5163afb
    http://lemon.cs.elte.hu/pub/sources
    FORCE)

message ("Installing ${lemon_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${lemon_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${lemon_URL}
    URL_MD5             ${lemon_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${lemon_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON_EXE}
    BUILD_COMMAND       devenv LEMON.sln /build Release /project ALL_BUILD
    INSTALL_COMMAND     devenv LEMON.sln /build Release /project INSTALL
)

set_target_properties(${lemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lemon_NAME)
