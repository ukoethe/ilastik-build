#
# Install vigra libraries from source
#

if (NOT vigra_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (jpeg)
include (tiff)
include (libpng)
include (fftw)
include (hdf5)
include (python)
include (boost)
include (numpy)

external_git_repo (vigra
    HEAD
    http://github.com/ukoethe/vigra.git)
    
message ("Installing ${vigra_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${vigra_NAME}
    DEPENDS             ${jpeg_NAME} ${tiff_NAME} ${libpng_NAME} ${fftw_NAME}
                        ${hdf5_NAME} ${python_NAME} ${boost_NAME} ${numpy_NAME} ${nose_NAME} ${sphinx_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    GIT_REPOSITORY      ${vigra_URL}
    UPDATE_COMMAND      ${GIT_EXECUTABLE} pull
    CONFIGURE_COMMAND   ${ADD_PATH} "${ILASTIK_DEPENDENCY_DIR}/bin" "${PYTHON_PREFIX}"
                     \n ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DDEPENDENCY_SEARCH_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON_EXE}
        -DHDF5_CPPFLAGS=-D_HDF5USEDLL_
    BUILD_COMMAND       devenv vigra.sln /build Release /project vigraimpex
                        \ndevenv vigra.sln /build Release /project vigranumpy
    TEST_COMMAND        "" # devenv vigra.sln /build Release /project check
    INSTALL_COMMAND     devenv vigra.sln /build Release /project INSTALL
)

set_target_properties(${vigra_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vigra_NAME)

