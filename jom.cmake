#
# Install jom from source
#

if (NOT jom_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)

set(jom_NAME jom-1.0.13)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/src/${jom_NAME}/jom.exe jom_EXE)

message ("Installing ${jom_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${jom_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 http://releases.qt-project.org/jom/jom.zip
    URL_MD5             d5310c97d9448c7d6a09d65bd81ddc1c
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${jom_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT jom_NAME)