#
# Install qt libraries from source
#

if (NOT qt_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

find_package(perl REQUIRED)

include (ExternalProject)
include (ExternalSource)
include (python)
include (zlib)
include (jpeg)
include (tiff)
include (libpng)
include (jom)

external_source (qt
    4.8.3
    qt-everywhere-opensource-src-4.8.3.tar.gz
    a663b6c875f8d7caa8ac9c30e4a4ec3b
    http://releases.qt-project.org/qt4/source
    FORCE)

message ("Installing ${qt_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

# #
# # This build script builds a SUBSET of QT.
# # We intentionally avoid building a lot of non-UI stuff, just to minimize our build time and minimize the odds of build system failures.
# # (This builds everything that ilastik needs.)

# The following version uses some magic to install Qt directly under ${ILASTIK_DEPENDENCY_DIR}.
# Below, we use a simpler approach that installs into ${ILASTIK_DEPENDENCY_DIR}/Qt4.

# file(TO_NATIVE_PATH ${qt_SRC_DIR} TMP_QTDIR)
# file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR} QTDIR)
# file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/bin QMAKE_PATH)

# set(QT_CONF_FILE ${ILASTIK_DEPENDENCY_DIR}/bin/qt.conf)
# FILE(WRITE  ${QT_CONF_FILE} "[Paths]\n")
# FILE(APPEND ${QT_CONF_FILE} "Prefix=${ILASTIK_DEPENDENCY_DIR}\n")
# FILE(APPEND ${QT_CONF_FILE} "Translations = translations\n")

# # Fixes install path in generated Makefiles (needed since Qt configure doesn't support --prefix on Windows)
# set (qt_install_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_qt_install_path.py ${qt_SRC_DIR} ${qt_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

# # Fixes install path in qmake.exe and *.prl (needed since Qt configure doesn't support --prefix on Windows)
# set (qmake_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_qmake.py ${ILASTIK_DEPENDENCY_DIR} ${qt_SRC_DIR})

# ExternalProject_Add(${qt_NAME}
    # DEPENDS             ${python_NAME}
    # PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    # URL                 ${qt_URL}
    # URL_MD5             ${qt_MD5}
    # UPDATE_COMMAND      ""
    # PATCH_COMMAND       ""
    # CONFIGURE_COMMAND   set QTDIR=${TMP_QTDIR}
       # \necho "yes" | .\\configure # pipe "yes" to stdin to accept the license.
        # # --prefix=${ILASTIK_DEPENDENCY_DIR}   # unsupported on Windows
        # # -optimized-qmake                     # unsupported on Windows
        # -opensource
        # -platform win32-msvc2010 
        # -I ${ILASTIK_DEPENDENCY_DIR}/include 
        # -L ${ILASTIK_DEPENDENCY_DIR}/lib
        # -mp
        # -nomake examples 
        # -nomake demos 
        # -nomake docs
        # -nomake translations 
        # -no-multimedia 
        # -no-webkit # Apparently clang segfaults when building webkit...
        # -no-audio-backend 
        # -no-phonon 
        # -no-phonon-backend 
        # -no-sql-sqlite 
        # -no-sql-sqlite2 
        # -no-sql-psql 
        # -no-sql-db2 
        # -no-sql-ibase 
        # -no-sql-mysql 
        # -no-sql-oci 
        # -no-sql-odbc
        # -no-sql-tds 
        # -no-dbus
        # -no-cups
        # -no-nis
        # -no-qt3support
        # -release 
        # -shared
        # -no-accessibility 
       # \n ${qt_install_PATCH} 
    # BUILD_IN_SOURCE     1
    # BUILD_COMMAND       nmake
    # TEST_COMMAND        "" # ${BUILDEM_ENV_STRING} make check
    # INSTALL_COMMAND     set INSTALL_ROOT=\n
                        # nmake install
                       # \n ${qmake_PATCH} 
# )

#
# This build script builds a SUBSET of QT.
# We intentionally avoid building a lot of non-UI stuff, just to minimize our build time and minimize the odds of build system failures.
# (This builds everything that ilastik needs.)

set(QT_BUILD_DIR ${ILASTIK_DEPENDENCY_DIR}/Qt4)
file(TO_NATIVE_PATH ${QT_BUILD_DIR} QTDIR)
file(TO_NATIVE_PATH ${QT_BUILD_DIR}/bin QMAKE_PATH)
file(TO_NATIVE_PATH ${qt_SRC_DIR}/configure QT_CONFIGURE_EXE)

# Patch names of system libraries (zlib, png, jpeg, tiff)
set (qt_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_qt.py ${qt_SRC_DIR})

if(MSVC11)
    # HashSet.h bug is not detected by earlier MSVC versions. It will hopefully be fixed in future Qt releases.
    set (qt_PATCH ${qt_PATCH}\n ${PATCH_EXE} -p0 -i ${PROJECT_SOURCE_DIR}/patches/patch_qt.patch )
endif()

configure_file(configure_qt.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_qt.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/configure_qt.bat QT_CONFIGURE_BAT)

configure_file(build_qt.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_qt.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_qt.bat QT_BUILD_BAT)

ExternalProject_Add(${qt_NAME}
    DEPENDS             ${python_NAME} ${zlib_NAME} ${jpeg_NAME} ${tiff_NAME} ${libpng_NAME} ${jom_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${qt_URL}
    URL_MD5             ${qt_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${qt_PATCH}
    BINARY_DIR          ${QT_BUILD_DIR}
    CONFIGURE_COMMAND   echo "yes" | call ${QT_CONFIGURE_BAT} # pipe "yes" to stdin to accept the license.
    BUILD_COMMAND       ${QT_BUILD_BAT}
    TEST_COMMAND        "" # nmake check
    INSTALL_COMMAND     nmake install
)

set_target_properties(${qt_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qt_NAME)

