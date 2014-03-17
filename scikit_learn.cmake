#
# Install scikit_learn library from source
#

if (NOT scikit_learn_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (python_packages)
include (numpy)
include (scipy)

external_source (scikit_learn
    0.14.1
    scikit-learn-0.14.1.tar.gz
    790ad23547bb7f428060636628e13491
    http://pypi.python.org/packages/source/s/scikit-learn
    FORCE)

configure_file(build_scikit_learn.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_scikit_learn.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_scikit_learn.bat SCIKIT_LEARN_BUILD_BAT)

message ("Installing ${scikit_learn_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${scikit_learn_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${scikit_learn_URL}
    URL_MD5             ${scikit_learn_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${SCIKIT_LEARN_BUILD_BAT}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scikit_learn_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scikit_learn_NAME)
