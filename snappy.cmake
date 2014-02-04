#
# Install snappy from source
#

if (NOT snappy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo(snappy
    HEAD
    https://github.com/ukoethe/snappy.git)
    
message ("Installing ${snappy_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${snappy_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${snappy_URL}
    UPDATE_COMMAND      "" # git pull
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${snappy_SRC_DIR}
                        -G ${CMAKE_GENERATOR}
                        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       ""
    TEST_COMMAND        "" 
    INSTALL_COMMAND     devenv snappy.sln /build Release /project INSTALL
)

set_target_properties(${snappy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT snappy_NAME)
