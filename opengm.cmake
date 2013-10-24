#
# Install opengm from source
#

if (NOT opengm_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo(opengm
    HEAD
    https://github.com/opengm/opengm.git)
    
message ("Installing ${opengm_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${opengm_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${opengm_URL}
    UPDATE_COMMAND      "" # git pull
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${opengm_SRC_DIR}
                        -G ${CMAKE_GENERATOR}
                        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
			-DWITH_CPLEX=ON
    BUILD_COMMAND       ""
    TEST_COMMAND        "" 
    INSTALL_COMMAND     devenv opengm2.sln /build Release /project INSTALL
)

set_target_properties(${opengm_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opengm_NAME)
