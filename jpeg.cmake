#
# Install jpeg from source
#

if (NOT jpeg_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (nasm)

external_source (jpeg
    1.2.1
    libjpeg-turbo-1.2.1.tar.gz
    f61e60ff01381ece4d2fe65eeb52669e
    http://sourceforge.net/projects/libjpeg-turbo/files/1.2.1
    FORCE)

message ("Installing ${jpeg_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${jpeg_NAME}
    DEPENDS             ${nasm_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${jpeg_URL}
    URL_MD5             ${jpeg_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${jpeg_SRC_DIR}
                         -G ${CMAKE_GENERATOR} 
                         -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
                         -DNASM=${nasm_EXE}
    BUILD_COMMAND       devenv libjpeg-turbo.sln /build Release /project simd
                      \ndevenv libjpeg-turbo.sln /build Release /project jpeg
                      \ndevenv libjpeg-turbo.sln /build Release /project jpeg-static
    INSTALL_COMMAND     devenv libjpeg-turbo.sln /build Release /project INSTALL
)

set_target_properties(${jpeg_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT jpeg_NAME)