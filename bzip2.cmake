#
# Install bzip2 from source
#

if (NOT bzip2_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (bzip2
    1.0.5                      # we must pretend it to be 1.0.5 because Python has this hard-wired
    bzip2-1.0.6.tar.gz
    00b516f4704d4a7cb50a1d97e6e8e15b
    http://www.bzip.org/1.0.6
    FORCE)

message ("Installing ${bzip2_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${bzip2_NAME}
    DEPENDS             ""
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${bzip2_URL}
    URL_MD5             ${bzip2_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_IN_SOURCE     1
    BUILD_COMMAND       "" # we don't have to build, will be built from Python directly
    INSTALL_COMMAND     ""
)

set_target_properties(${bzip2_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT bzip2_NAME)