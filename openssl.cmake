#
# Install openssl from source
#

if (NOT openssl_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (openssl
    1.0.1e
    openssl-1.0.1e.tar.gz
    7b5149eb6a145a0c8f8ee93e172c2d09
    http://hci.iwr.uni-heidelberg.de/Software/ilastik-dependencies
    FORCE)
        
message ("Installing ${openssl_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
# ExternalProject_Add(${openssl_NAME}
    # PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    # URL                 ${openssl_URL}
    # URL_MD5             ${openssl_MD5}
    # UPDATE_COMMAND      ""
    # PATCH_COMMAND       ""
    # CONFIGURE_COMMAND   ${ADD_PATH} "${PERL_PATH}"
                      # \nwhere perl
                      # \necho using perl
                      # \nperl Configure VC-WIN64A --prefix=${ILASTIK_DEPENDENCY_DIR}
                      # \ncall ms\\do_win64a.bat
    # BUILD_COMMAND       ${ADD_PATH} "${PERL_PATH}"
                      # \nnmake /f ms\\nt.mak
    # BUILD_IN_SOURCE     1
    # INSTALL_COMMAND     ${ADD_PATH} "${PERL_PATH}"
                      # \nnmake /f ms\\nt.mak install
                      # \ncopy tmp32/buildinf.h crypto\\buildinf_x86.h
                      # \ncopy inc32\\openssl\\opensslconf.h crypto\\opensslconf_x86.h
# )

# we only need to download openssl, compilation is performed by the Python build
ExternalProject_Add(${openssl_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${openssl_URL}
    URL_MD5             ${openssl_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${openssl_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openssl_NAME)
