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
    
# Patch compiler settings
set (cylemon_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_cylemon.py ${cylemon_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

message ("Installing ${cylemon_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/ilastik ...")
ExternalProject_Add(${cylemon_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${lemon_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${cylemon_URL}
    PATCH_COMMAND       ${cylemon_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       python setup.py build
    INSTALL_COMMAND     python setup.py install
    BUILD_IN_SOURCE     1
)

set_target_properties(${cylemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cylemon_NAME)

