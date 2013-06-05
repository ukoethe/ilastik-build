#
# Install pgmlink libraries from source
#

if (NOT pgmlink_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (ann)
include (boost)
include (vigra)
include (opengm)
include (lemon)
include (python)
include (hdf5)

external_git_repo (pgmlink
    HEAD
    http://github.com/ilastik/pgmlink.git)
    
message ("Installing ${pgmlink_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${pgmlink_NAME}
    DEPENDS             ${ann_NAME} ${boost_NAME} ${vigra_NAME} ${opengm_NAME} ${lemon_NAME} ${python_NAME} ${hdf5_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${pgmlink_URL}
    UPDATE_COMMAND      "" # git pull
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${pgmlink_SRC_DIR}
                        -G ${CMAKE_GENERATOR}
			-DCMAKE_BUILD_TYPE=Release
                        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
                        -DCMAKE_PREFIX_PATH=${ILASTIK_DEPENDENCY_DIR}
			-DWITH_CHECKED_STL=OFF
			-DWITH_PYTHON=ON
			-DWITH_TESTS=OFF
			-DPYTHON_EXECUTABLE=${PYTHON_EXE}
			-DPYTHON_INCLUDE_DIRS=${PYTHON_INCLUDE_PATH}
			-DPYTHON_LIBRARIES=${PYTHON_LIBRARY_FILE}
    BUILD_COMMAND       devenv pgmlink.sln /build Release /project pgmlink
                        \ndevenv pgmlink.sln /build Release /project pypgmlink
    TEST_COMMAND        "" # devenv pgmlink.sln /build Release /project check
    INSTALL_COMMAND     devenv pgmlink.sln /build Release /project INSTALL
)

set_target_properties(${pgmlink_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pgmlink_NAME)

