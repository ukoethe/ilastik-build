#
# Install libxml2 from source
#

if (NOT libxml2_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (iconv)

external_source (libxml2
    2.9.1
    libxml2-2.9.1.tar.gz
    9c0cfef285d5c4a5c80d00904ddab380
    ftp://xmlsoft.org/libxml2
    FORCE)

message ("Installing ${libxml2_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${libxml2_NAME}
    DEPENDS             ${iconv_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${libxml2_URL}
    URL_MD5             ${libxml2_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   cd win32
                      \ncscript configure.js compiler=msvc 
                        prefix=${ILASTIK_DEPENDENCY_DIR_DOS}
                        include=${ILASTIK_DEPENDENCY_DIR_DOS}\\include 
                        lib=${ILASTIK_DEPENDENCY_DIR_DOS}\\lib debug=no
    BUILD_COMMAND       cd win32
                      \nnmake /f Makefile.msvc
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     cd win32
                      \nnmake /f Makefile.msvc install
)

set_target_properties(${libxml2_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libxml2_NAME)
