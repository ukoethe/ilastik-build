#
# Install iconv from source
#

if (NOT iconv_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (iconv
    1.14
    libiconv-1.14.tar.gz
    e34509b1623cec449dfeb73d7ce9c6c6
    http://ftp.gnu.org/pub/gnu/libiconv/
    FORCE)

if(NOT EXISTS ${MSYS_PATH}/make.exe)
    MESSAGE(FATAL_ERROR "ERROR: make.exe not found in MSYS_PATH '${MSYS_PATH}'")
endif()

configure_file(build_iconv.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_iconv.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_iconv.bat ICONV_BUILD_BAT)

message ("Installing ${iconv_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${iconv_NAME}
    DEPENDS             ""
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${iconv_URL}
    URL_MD5             ${iconv_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${ADD_PATH} "${MSYS_PATH}" "${MINGW_PATH}"
                      \nsh configure
    BUILD_COMMAND       ${ICONV_BUILD_BAT}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     "" # ${ICONV_BUILD_BAT} already installs
)

set_target_properties(${iconv_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT iconv_NAME)
