#
# Install scipy from source
#

if (NOT scipy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (numpy)
include (emulate_c99)

external_source (scipy
    0.11.0
    scipy-0.11.0.tar.gz
    842c81d35fd63579c41a8ca21a2419b9
    http://downloads.sourceforge.net/project/scipy/scipy/0.11.0
    FORCE)

if(${ILASTIK_BITNESS} STREQUAL "32")
#    set(OPENBLAS_PARALLEL_BUILD "")
    set(SCIPY_MACHINE "/MACHINE:X86")
else()
#    set(OPENBLAS_PARALLEL_BUILD "-j6")
    set(SCIPY_MACHINE "/MACHINE:X64")
endif()

configure_file(build_scipy.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_scipy.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_scipy.bat SCIPY_BUILD_BAT)

# Download and install scipy
message ("Installing ${scipy_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${scipy_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${emulate_c99_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${scipy_URL}
    URL_MD5             ${scipy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${SCIPY_BUILD_BAT}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     "" # ${SCIPY_BUILD_BAT} already installed the package
)

set_target_properties(${scipy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scipy_NAME)
