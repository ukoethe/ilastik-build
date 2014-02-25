#
# Install OpenBLAS from source
#

if (NOT openblas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo (openblas
    0.2.5
    http://github.com/xianyi/OpenBLAS)
    
if(NOT EXISTS ${MINGW_PATH}/gfortran.exe)
    MESSAGE(FATAL_ERROR "ERROR: gfortran.exe not found in MINGW_PATH '${MINGW_PATH}'")
endif()
    
if(NOT EXISTS ${MSYS_PATH}/make.exe)
    MESSAGE(FATAL_ERROR "ERROR: make.exe not found in MSYS_PATH '${MSYS_PATH}'")
endif()

configure_file(build_openblas.bat.in ${ILASTIK_DEPENDENCY_DIR}/tmp/build_openblas.bat)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/tmp/build_openblas.bat OPENBLAS_BUILD_BAT)

# NOTE: 'make' downloads and compiles lapack-3.4.2 on the fly and puts blas and lapack
#       together into libopenblas.dll. numpy wants two separate libraries, so we copy the
#       link library libopenblas.lib under the two names blas.lib and lapack.lib.

message ("Installing ${openblas_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${openblas_NAME}
#    DEPENDS            
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${openblas_URL}
    GIT_TAG             v0.2.5
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${OPENBLAS_BUILD_BAT}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     "" # ${OPENBLAS_BUILD_BAT} already installs
)

set_target_properties(${openblas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openblas_NAME)