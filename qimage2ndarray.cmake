#
# Install qimage2ndarray libraries from source
#

if (NOT qimage2ndarray_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (numpy)
include (pyqt)

external_git_repo (qimage2ndarray
    release-1.3
    https://github.com/hmeine/qimage2ndarray.git)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # This patch does no harm on non-mac builds, but there's no need to apply it on linux.
    set (qimage2ndarray_PATCH ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        ${qimage2ndarray_SRC_DIR}/setup.py ${PATCH_DIR}/qimage2ndarray.patch )
elseif(WIN32)
    set (qimage2ndarray_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_qimage2ndarray.py ${qimage2ndarray_SRC_DIR})
else()
    set (qimage2ndarray_PATCH "")
endif()

message ("Installing ${qimage2ndarray_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${qimage2ndarray_NAME}
    DEPENDS             ${numpy_NAME} ${pyqt_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${qimage2ndarray_URL}
    UPDATE_COMMAND      ""
#    PATCH_COMMAND       ${qimage2ndarray_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin" "${ILASTIK_DEPENDENCY_DIR}/Qt4/bin"
                     \n ${PYTHON_EXE} setup.py build
    INSTALL_COMMAND     ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin" "${ILASTIK_DEPENDENCY_DIR}/Qt4/bin"
                     \n ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
)

set_target_properties(${qimage2ndarray_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qimage2ndarray_NAME)
