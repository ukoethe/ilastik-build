#
# Install python from source
#
# Defines the following:
#    PYTHON_INCLUDE_PATH
#    PYTHON_EXE -- path to python executable

if (NOT python_virtualenv_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)

external_source (python_virtualenv
    1.8.4
    virtualenv-1.8.4.tar.gz
    1c7e56a7f895b2e71558f96e365ee7a7
    http://pypi.python.org/packages/source/v/virtualenv
    FORCE)

message ("Creating Python virtual environment in ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/python ...")

ExternalProject_Add(${python_virtualenv_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${python_virtualenv_URL}
    URL_MD5             ${python_virtualenv_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       "" 
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_BOOTSTRAP_EXE} virtualenv.py ${ILASTIK_DEPENDENCY_DIR}/python
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

# set (PYTHON_INCLUDE_PATH ${PYTHON_PREFIX}/include/python2.7)
# set (PYTHON_LIBRARY_FILE ${PYTHON_PREFIX}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION})
set (PYTHON_EXE ${ILASTIK_DEPENDENCY_DIR}/python/Scripts/python.exe)

set_target_properties(${python_virtualenv_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_virtualenv_NAME)
