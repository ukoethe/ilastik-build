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

message ("Installing ${pyqt_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    external_source (pyqt
        4.9.5
        PyQt-mac-gpl-4.9.5.tar.gz
        855f9d9e10821c0f79a7dc956a9a14ec    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.9.5)

    set (EXTRA_PYQT4_CONFIG_FLAGS
        --use-arch=x86_64)
elseif (${WIN32})
    external_source (pyqt
        4.9.5
        PyQt-win-gpl-4.9.5.zip
        0ebc1b0c27b49c22492a3145f5f1ee47
        http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.9.5
        FORCE)
elseif (${UNIX})
    external_source (pyqt
        4.9.5
        PyQt-x11-gpl-4.9.5.tar.gz
        e4cdd6619c63655f7510efb4df8462fb    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.9.5)
else ()
    message (FATAL_ERROR "ERROR: Cannot detect valid system in pyqt cmake file")
endif()

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

