#
# Install matplotlib library from source
#

if (NOT spyder_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (python_packages)
include (numpy)
include (pyqt)

external_source (spyder
    2.1.13 
    spyder-2.1.13.zip
    d3d129876bc980287e1ae4f5ff147ffb
    http://spyderlib.googlecode.com/files
    FORCE)

message ("Installing ${spyder_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${spyder_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${nose_NAME} ${sphinx_NAME} ${pyflakes_NAME} ${rope_NAME}
                        ${pygments_NAME} ${pylint_NAME} ${pep8_NAME} ${pyqt_NAME} ${numpy_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${spyder_URL}
    URL_MD5             ${spyder_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${spyder_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT spyder_NAME)
