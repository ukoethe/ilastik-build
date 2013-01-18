#
# Install matplotlib library from source
#

if (NOT matplotlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (numpy)
include (libpng)
include (freetype)
include (pyqt)

external_source (matplotlib
    1.2.0
    matplotlib-1.2.0.tar.gz
    c52e2c5a09eca910d8d166dcbd2d01ec
    http://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.2.0
    FORCE)

# insert library dependencies
set (matplotlib_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_matplotlib.py ${matplotlib_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

message ("Installing ${matplotlib_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${matplotlib_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${libpng_NAME} ${freetype_NAME} # ${pyqt_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${matplotlib_URL}
    URL_MD5             ${matplotlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${matplotlib_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${matplotlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT matplotlib_NAME)
