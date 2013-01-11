#
# Install nasm from source
#

if (NOT nasm_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)

set(nasm_NAME nasm-2.10)
set(nasm_EXECUTABLE ${ILASTIK_DEPENDENCY_DIR}/bin/nasm.exe)

message ("Installing ${nasm_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${nasm_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 http://www.nasm.us/pub/nasm/releasebuilds/2.10.07/win32/nasm-2.10.07-win32.zip
    URL_MD5             1dafe433d8c83854188934617eec3032
    UPDATE_COMMAND      ""
    PATCH_COMMAND       "" # ${nasm_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy ${ILASTIK_DEPENDENCY_DIR}/src/${nasm_NAME}/nasm.exe ${ILASTIK_DEPENDENCY_DIR}/bin
)

set_target_properties(${nasm_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT nasm_NAME)