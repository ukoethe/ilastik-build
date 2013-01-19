#
# Install vigraqt libraries from source
#

if (NOT vigraqt_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (vigra)
include (pyqt)

external_source (vigraqt
    0.6
    vigraqt4-0.6.tar.gz
    cd030e8ba74120e8d5f5a0339f45e483
    http://kogs-www.informatik.uni-hamburg.de/~meine/software/vigraqt/
    FORCE)

set (vigraqt_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_vigraqt.py ${vigraqt_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

message ("Installing ${vigraqt_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${vigraqt_NAME}
    DEPENDS             ${vigra_NAME} ${pyqt_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${vigraqt_URL}
    URL_MD5             ${vigraqt_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${vigraqt_PATCH}
    BINARY_DIR          ${vigraqt_SRC_DIR}/src/vigraqt
    CONFIGURE_COMMAND   ${QMAKE_PATH}\\qmake INSTALLBASE=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       nmake
    INSTALL_COMMAND     nmake install
)

set(pyvigraqt_NAME "py${vigraqt_NAME}")

ExternalProject_Add(${pyvigraqt_NAME}
    DEPENDS             ${vigraqt_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    DOWNLOAD_COMMAND    ""
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    BINARY_DIR          ${vigraqt_SRC_DIR}/src/sip
    CONFIGURE_COMMAND   ${PYTHON_EXE} configure.py
    BUILD_COMMAND       nmake
    INSTALL_COMMAND     nmake install
)

set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${pyvigraqt_NAME})

set_target_properties(${vigraqt_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set_target_properties(${pyvigraqt_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vigraqt_NAME)
