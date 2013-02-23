#
# Install numpy from source
#

if (NOT numpy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (numpy
    1.6.2
    numpy-1.6.2.tar.gz
    95ed6c9dcc94af1fc1642ea2a33c1bba
    http://downloads.sourceforge.net/project/numpy/NumPy/1.6.2
    FORCE)
message ("Installing ${numpy_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
    
include (python)

if(WITH_SCIPY)
    include (openblas)
    configure_file(configure_numpy.cfg.in ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_numpy.cfg)

    ExternalProject_Add(${numpy_NAME}
        DEPENDS             ${python_NAME} ${openblas_NAME}
        PREFIX              ${ILASTIK_DEPENDENCY_DIR}
        URL                 ${numpy_URL}
        URL_MD5             ${numpy_MD5}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/patch_numpy.patch
        CONFIGURE_COMMAND   ${CMAKE_COMMAND} -E copy ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_numpy.cfg ${numpy_SRC_DIR}/site.cfg
        BUILD_COMMAND       ${PYTHON_EXE} setup.py build
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
    )
else()
    ExternalProject_Add(${numpy_NAME}
        DEPENDS             ${python_NAME}
        PREFIX              ${ILASTIK_DEPENDENCY_DIR}
        URL                 ${numpy_URL}
        URL_MD5             ${numpy_MD5}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/patch_numpy.patch
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ${PYTHON_EXE} setup.py build
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
    )
endif()

set_target_properties(${numpy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT numpy_NAME)
