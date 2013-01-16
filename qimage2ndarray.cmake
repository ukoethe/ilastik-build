#
# Install qimage2ndarray libraries from source
#

if (NOT qimage2ndarray_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (numpy)
include (pyqt)

external_source (qimage2ndarray
    1.0
    qimage2ndarray-1.0.tar.gz
    1f59c1c42395709a58c43ed74a866375    
    http://kogs-www.informatik.uni-hamburg.de/~meine/software/qimage2ndarray/dist
    FORCE)

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
    URL                 ${qimage2ndarray_URL}
    URL_MD5             ${qimage2ndarray_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${qimage2ndarray_PATCH}
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
)

set_target_properties(${qimage2ndarray_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qimage2ndarray_NAME)
