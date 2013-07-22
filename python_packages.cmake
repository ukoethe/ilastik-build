#
# Install python packages from source
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)

####################################################################

if (NOT sqlite_NAME)

external_source (sqlite
    3.7.15
    sqlite-amalgamation-3071502.zip
    7f95fd6b0d69a9773ef0258e9f4f3035
    http://www.sqlite.org/
    FORCE)

# Fix path to sqlite sources in pyproject.props
set (sqlite_CONFIG ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_python_sqlite.py ${PYTHON_BIN_DIR})

SET(sqlite_INSTALL ${ILASTIK_DEPENDENCY_DIR}/tmp/sqlite_install.cmake)
FILE(WRITE   ${sqlite_INSTALL} "file(INSTALL amd64/_sqlite3.pyd amd64/sqlite3.dll DESTINATION ${PYTHON_PREFIX}/DLLs)\n")
FILE(APPEND  ${sqlite_INSTALL} "file(INSTALL amd64/sqlite3.lib DESTINATION ${PYTHON_PREFIX}/libs)\n")

message ("Installing ${sqlite_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${sqlite_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${sqlite_URL}
    URL_MD5             ${sqlite_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    BINARY_DIR          ${PYTHON_BIN_DIR}
    CONFIGURE_COMMAND   ${sqlite_CONFIG}
    BUILD_COMMAND       devenv PCbuild.sln /build "Release|x64" /project _sqlite3
    INSTALL_COMMAND     ${CMAKE_COMMAND} -P ${sqlite_INSTALL}
)

# the following code actually compiles sqlite, but this is not needed because
# Python compiles it directly from sources
#############################################################################
# SET(sqlite_CONFIG ${ILASTIK_DEPENDENCY_DIR}/tmp/sqlite_config.cmake)
# FILE(WRITE   ${sqlite_CONFIG} "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)\n")
# FILE(APPEND  ${sqlite_CONFIG} "project (sqlite3)\n")
# FILE(APPEND  ${sqlite_CONFIG} "ADD_LIBRARY(sqlite3 STATIC shell.c sqlite3.c)\n")
# FILE(APPEND  ${sqlite_CONFIG} "INSTALL(TARGETS sqlite3 RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)\n")
# FILE(APPEND  ${sqlite_CONFIG} "INSTALL(FILES sqlite3.h sqlite3ext.h DESTINATION include)\n")

# message ("Installing ${sqlite_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
# ExternalProject_Add(${sqlite_NAME}
    # PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    # URL                 ${sqlite_URL}
    # URL_MD5             ${sqlite_MD5}
    # UPDATE_COMMAND      ""
    # PATCH_COMMAND       ${CMAKE_COMMAND} -E copy ${ILASTIK_DEPENDENCY_DIR}/tmp/sqlite_config.cmake ${sqlite_SRC_DIR}/CMakeLists.txt
    # CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${sqlite_SRC_DIR}
                         # -G ${CMAKE_GENERATOR} 
                         # -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    # BUILD_COMMAND       devenv sqlite3.sln /build Release /project sqlite3
    # INSTALL_COMMAND     devenv sqlite3.sln /build Release /project INSTALL
# )

set_target_properties(${sqlite_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT sqlite_NAME)

####################################################################

if (NOT setuptools_NAME)

external_source (setuptools
    0.6c11
    setuptools-0.6c11.tar.gz
    7df2a529a074f613b509fb44feefe74e
    http://pypi.python.org/packages/source/s/setuptools
    FORCE)

# Download and install setuptools
message ("Installing ${setuptools_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

ExternalProject_Add(${setuptools_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${setuptools_URL}
    URL_MD5             ${setuptools_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${setuptools_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT setuptools_NAME)

####################################################################

if (NOT pip_NAME)

external_source (pip
    1.2.1
    pip-1.2.1.tar.gz
    db8a6d8a4564d3dc7f337ebed67b1a85
    http://pypi.python.org/packages/source/p/pip
    FORCE)

# Download and install pip
message ("Installing ${pip_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pip_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pip_URL}
    URL_MD5             ${pip_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${pip_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pip_NAME)

####################################################################

if (NOT docopt_NAME)

external_source (docopt
    0.6.1
    docopt-0.6.1.tar.gz
    fe36e9b7a1708a0b02a115f2a78cf623
    https://pypi.python.org/packages/source/d/docopt
    FORCE)

# Download and install docopt
message ("Installing ${docopt_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${docopt_NAME}
    DEPENDS             ${python_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${docopt_URL}
    URL_MD5             ${docopt_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${docopt_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT docopt_NAME)

####################################################################

if (NOT docutils_NAME)

external_source (docutils
    0.10
    docutils-0.10.tar.gz
    d8d4660c08302c791b2d71a155a2f4bc
    https://pypi.python.org/packages/source/d/docutils
    FORCE)

# Download and install docutils
message ("Installing ${docutils_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${docutils_NAME}
    DEPENDS             ${python_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${docutils_URL}
    URL_MD5             ${docutils_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${docutils_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT docutils_NAME)

####################################################################

if (NOT markupsafe_NAME)

external_source (markupsafe
    0.18
    MarkupSafe-0.18.tar.gz
    f8d252fd05371e51dec2fe9a36890687
    https://pypi.python.org/packages/source/M/MarkupSafe/
    FORCE)

# Download and install markupsafe
message ("Installing ${markupsafe_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${markupsafe_NAME}
    DEPENDS             ${python_NAME} 
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${markupsafe_URL}
    URL_MD5             ${markupsafe_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${markupsafe_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT markupsafe_NAME)

##################################################

if (NOT jinja2_NAME)
external_source (jinja2
    2.7
    Jinja2-2.7.tar.gz
    c2fb12cbbb523c57d3d15bfe4dc0e8fe
    https://pypi.python.org/packages/source/J/Jinja2/
    FORCE)

message ("Installing ${jinja2_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${jinja2_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${markupsafe_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${jinja2_URL}
    URL_MD5             ${jinja2_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${jinja2_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT jinja2_NAME)


##################################################

if (NOT pygments_NAME)
external_source (pygments
    1.6
    Pygments-1.6.tar.gz
    a18feedf6ffd0b0cc8c8b0fbdb2027b1
    http://pypi.python.org/packages/source/P/Pygments/
    FORCE)

message ("Installing ${pygments_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pygments_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pygments_URL}
    URL_MD5             ${pygments_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pygments_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pygments_NAME)


####################################################################

if (NOT nose_NAME)

external_source (nose
    1.2.1
    nose-1.2.1.tar.gz
    735e3f1ce8b07e70ee1b742a8a53585a
    http://pypi.python.org/packages/source/n/nose
    FORCE)

message ("Installing ${nose_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${nose_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${nose_URL}
    URL_MD5             ${nose_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${nose_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT nose_NAME)

####################################################################

if (NOT sphinx_NAME)

external_source (sphinx
    1.1.3
    Sphinx-1.1.3.tar.gz
    8f55a6d4f87fc6d528120c5d1f983e98
    http://pypi.python.org/packages/source/S/Sphinx
    FORCE)

message ("Installing ${sphinx_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${sphinx_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${docutils_NAME} ${jinja2_NAME} ${pygments_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${sphinx_URL}
    URL_MD5             ${sphinx_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${sphinx_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT sphinx_NAME)

####################################################################

if (NOT cython_NAME)

external_source (cython
    0.17.4
    Cython-0.17.4.tar.gz
    cb11463e3a0c8d063e578db64ff61dde
    http://pypi.python.org/packages/source/C/Cython
    FORCE)

message ("Installing ${cython_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${cython_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${cython_URL}
    URL_MD5             ${cython_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${cython_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT cython_NAME)

####################################################################

if (NOT greenlet_NAME)

external_source (greenlet
    0.4.0
    greenlet-0.4.0.zip
    87887570082caadc08fb1f8671dbed71
    http://pypi.python.org/packages/source/g/greenlet
    FORCE)

message ("Installing ${greenlet_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${greenlet_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${greenlet_URL}
    URL_MD5             ${greenlet_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${greenlet_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT greenlet_NAME)

####################################################################

if (NOT blist_NAME)

external_source (blist
    1.3.4
    blist-1.3.4.tar.gz
    02e8bf33cffec9cc802f4567f39ffa6f
    http://pypi.python.org/packages/source/b/blist
    FORCE)

message ("Installing ${blist_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${blist_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${blist_URL}
    URL_MD5             ${blist_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${blist_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT blist_NAME)

####################################################################

if (NOT psutil_NAME)

external_source (psutil
    0.6.1
    psutil-0.6.1.tar.gz
    3cfcbfb8525f6e4c70110e44a85e907e
    http://psutil.googlecode.com/files
    FORCE)

message ("Installing ${psutil_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${psutil_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${psutil_URL}
    URL_MD5             ${psutil_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${psutil_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT psutil_NAME)

####################################################################

if (NOT sip_NAME)

external_source (sip
    4.14.2
    sip-4.14.2.tar.gz
    b93442e745b3be2fad89de0686a76ce9
    http://sourceforge.net/projects/pyqt/files/sip/sip-4.14.2
    FORCE)

message ("Installing ${sip_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${sip_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${sip_URL}
    URL_MD5             ${sip_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${PYTHON_EXE} configure.py
    BUILD_COMMAND       nmake
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     nmake install
)

set_target_properties(${sip_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT sip_NAME)

if (NOT pyopengl_NAME)

external_source (pyopengl
    3.0.2
    PyOpenGL-3.0.2.tar.gz
    77becc24ffc0a6b28030aa109ad7ff8b
    http://pypi.python.org/packages/source/P/PyOpenGL
    FORCE)

message ("Installing ${pyopengl_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pyopengl_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pyopengl_URL}
    URL_MD5             ${pyopengl_MD5}
    UPDATE_COMMAND      ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pyopengl_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pyopengl_NAME)

####################################################################

if (NOT pyreadline_NAME)

external_source (pyreadline
    1.7.1
    pyreadline-1.7.1.zip
    293d4e8794f867c122d4290ccc84be8d
    http://pypi.python.org/packages/source/p/pyreadline
    FORCE)

message ("Installing ${pyreadline_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pyreadline_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pyreadline_URL}
    URL_MD5             ${pyreadline_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pyreadline_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pyreadline_NAME)

####################################################################

if (NOT pyzmq_NAME)

external_source (pyzmq
    2.2.0
    pyzmq-2.2.0.1.tar.gz
    f2f80709e84c8ac72d6671eee645d804
	http://pypi.python.org/packages/source/p/pyzmq
	FORCE)

message ("Installing ${pyzmq_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pyzmq_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pyzmq_URL}
    URL_MD5             ${pyzmq_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py --zmq=bundled install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pyzmq_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pyzmq_NAME)

####################################################################

if (NOT tornado_NAME)

# FIXME: this download doesn't work (but it works in the Browser)
external_source (tornado
    2.4.1
    tornado-2.4.1.tar.gz
    9b7146cbe7cce015e35856b592707b9b
    http://pypi.python.org/packages/source/t/tornado
    FORCE)

message ("Installing ${tornado_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${tornado_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${tornado_URL}
    URL_MD5             ${tornado_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${tornado_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT tornado_NAME)

####################################################################

if (NOT futures_NAME)

external_source (futures
    2.1.3
    futures-2.1.3.tar.gz
    3de68835c8035dff0495cbe7f5c75beb
    https://pypi.python.org/packages/source/f/futures
    FORCE)

message ("Installing ${futures_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${futures_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${futures_URL}
    URL_MD5             ${futures_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${futures_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT futures_NAME)

####################################################################

if (NOT yapsy_NAME)

external_source (yapsy
    1.10.1
    Yapsy-1.10.1-pythons2n3.tar.gz
    468274aa078bd56a5ab4a41cd6c0c8ef
    https://pypi.python.org/packages/source/Y/Yapsy
    FORCE)

message ("Installing ${yapsy_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${yapsy_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${yapsy_URL}
    URL_MD5             ${yapsy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${yapsy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT yapsy_NAME)

####################################################################

if (NOT pyflakes_NAME)
external_source (pyflakes
    0.7
    pyflakes-0.7.tar.gz
    4cbe17be937684654eb29d9efab67b80
    http://pypi.python.org/packages/source/p/pyflakes
    FORCE)

message ("Installing ${pyflakes_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pyflakes_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pyflakes_URL}
    URL_MD5             ${pyflakes_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pyflakes_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT pyflakes_NAME)

##################################################

if (NOT rope_NAME)
external_source (rope
    0.9.4
    rope-0.9.4.tar.gz
    6c654c6892f78008e04e2d65f9f859bb
    http://pypi.python.org/packages/source/r/rope
    FORCE)

message ("Installing ${rope_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${rope_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${rope_URL}
    URL_MD5             ${rope_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${rope_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT rope_NAME)

####################################################################

if (NOT colorama_NAME)

external_source (colorama
    0.2.5
    colorama-0.2.5.tar.gz
    308c6e38917bdbfc4d3b0783c614897d
    http://pypi.python.org/packages/source/c/colorama
    FORCE)

message ("Installing ${colorama_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${colorama_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${colorama_URL}
    URL_MD5             ${colorama_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${colorama_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT colorama_NAME)

############################################

if (NOT logilab_common_NAME)
external_source (logilab_common
    0.59.1
    logilab-common-0.59.1.tar.gz
    14b3becc67397cdc4b51ced617f2982b
    https://pypi.python.org/packages/source/l/logilab-common
    FORCE)

message ("Installing ${logilab_common_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${logilab_common_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${colorama_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${logilab_common_URL}
    URL_MD5             ${logilab_common_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${logilab_common_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif ()

############################################

if (NOT logilab_astng_NAME)
external_source (logilab_astng
    0.24.3
    logilab-astng-0.24.3.tar.gz
    f0dd5dee1d5053939da174e1bfe69388
    http://pypi.python.org/packages/source/l/logilab-astng
    FORCE)

message ("Installing ${logilab_astng_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${logilab_astng_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${logilab_common_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${logilab_astng_URL}
    URL_MD5             ${logilab_astng_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${logilab_astng_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif ()

####################################################################

if (NOT grin_NAME)

external_source (grin
    1.2.1
    grin-1.2.1.tar.gz
    d894426dfbf70bc105388c2a51348199
    https://pypi.python.org/packages/source/g/grin
    FORCE)

message ("Installing ${grin_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${grin_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${grin_URL}
    URL_MD5             ${grin_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${grin_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT grin_NAME)

############################################

if (NOT pylint_NAME)
external_source (pylint
    0.27.0
    pylint-0.27.0.tar.gz
    7819fec3ce3e720f30e508b8a88cf59b
    http://pypi.python.org/packages/source/p/pylint
    FORCE)

message ("Installing ${pylint_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pylint_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${colorama_NAME} ${logilab_astng_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pylint_URL}
    URL_MD5             ${pylint_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pylint_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif ()

############################################

if (NOT pep8_NAME)
external_source (pep8
    1.4.5
    pep8-1.4.5.tar.gz
    055dbd22ac5669232fdba752612e9686
    http://pypi.python.org/packages/source/p/pep8
    FORCE)

message ("Installing ${pep8_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pep8_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pep8_URL}
    URL_MD5             ${pep8_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pep8_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

####################################################################

if (NOT ipython_NAME)

external_source (ipython
    0.13.1
    ipython-0.13.1.tar.gz
    ca7e75f7c802afc6aaa0a1ea59846420
    http://pypi.python.org/packages/source/i/ipython
    FORCE)

message ("Installing ${ipython_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${ipython_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${pyreadline_NAME} ${sqlite_NAME} ${pyzmq_NAME} ${tornado_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${ipython_URL}
    URL_MD5             ${ipython_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${ipython_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)


endif (NOT ipython_NAME)

endif ()


