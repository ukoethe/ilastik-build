#
# Install pyqt libraries from source
#

if (NOT pyqt_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (python_packages)
include (qt)
#include (jom)

message ("Installing ${pyqt_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

external_source (pyqt
    4.10.3
    PyQt-win-gpl-4.10.3.zip
    14f09b0ed9f04daf8f19f680d3b90e8b
    http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.10.3
    FORCE)

configure_file(configure_pyqt.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_pyqt.bat)
configure_file(build_pyqt.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_pyqt.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_pyqt.bat PYQT_CONFIGURE_BAT)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_pyqt.bat PYQT_BUILD_BAT)

ExternalProject_Add(${pyqt_NAME}
    DEPENDS             ${python_NAME} ${sip_NAME} ${qt_NAME}             
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pyqt_URL}
    URL_MD5             ${pyqt_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    # PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        # ${pyqt_SRC_DIR}/configure.py ${PATCH_DIR}/pyqt.patch # For some reason, the configure script wants to build pyqt phonon support even if qt was built without it.  This patch simply comments out phonon support. The patch is apparently not needed in Windows.
    CONFIGURE_COMMAND   call ${PYQT_CONFIGURE_BAT}
    BUILD_COMMAND       call ${PYQT_BUILD_BAT}
    INSTALL_COMMAND     nmake install
    BUILD_IN_SOURCE 1
)

set_target_properties(${pyqt_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyqt_NAME)

