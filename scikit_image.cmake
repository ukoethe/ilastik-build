#
# Install scikit__image library from source
#

if (NOT scikit_image_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (python_packages)
include (numpy)
include (scipy)

external_source (scikit_image
    0.8.2
    scikit-image-0.8.2.tar.gz
    9f5184c43f9fc1e9f43feea161b9f081
    http://pypi.python.org/packages/source/s/scikit-image
    FORCE)

message ("Installing ${scikit_image_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${scikit_image_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${scikit_image_URL}
    URL_MD5             ${scikit_image_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin" "${PYTHON_PREFIX}"
                     \n ${PYTHON_EXE} setup.py build_ext -c msvc install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scikit_image_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scikit_image_NAME)
