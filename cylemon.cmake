#
# Install cylemon libraries from source
#
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (numpy)
include (lemon)

if (NOT cylemon_NAME)

external_git_repo (cylemon
    HEAD
    https://github.com/cstraehl/cylemon.git)
    
message ("Installing ${cylemon_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/ilastik ...")
ExternalProject_Add(${cylemon_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${lemon_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${cylemon_URL}
    UPDATE_COMMAND      ${GIT_EXECUTABLE} pull
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin"
                     \n ${PYTHON_EXE} setup.py build_ext -I ${ILASTIK_DEPENDENCY_DIR}/include -L ${ILASTIK_DEPENDENCY_DIR}/lib -c msvc
    INSTALL_COMMAND     ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin"
                     \n ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
)

set_target_properties(${cylemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cylemon_NAME)

