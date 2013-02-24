#
# Install vtk libraries from source
#

if (NOT vtk_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (python_packages)
include (qt)
include (pyqt)
include (jpeg)
include (tiff)
include (libpng)
include (hdf5)
include (freetype)

external_source (vtk
    5.10.1
    vtk-5.10.1.tar.gz
    264b0052e65bd6571a84727113508789
    http://www.vtk.org/files/release/5.10
    FORCE)

# FIXME: 
#  * how to specify location of qmake?
#  * how to compile without Tcl ?

message ("Installing ${vtk_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")

string(REGEX REPLACE "/" "\\\\\\\\" PYTHON_PREFIX_SLASH ${ILASTIK_DEPENDENCY_DIR}/python)

ExternalProject_Add(${vtk_NAME}
    DEPENDS             ${python_NAME} ${qt_NAME} ${sip_NAME} ${pyqt_NAME} ${hdf5_NAME} ${jpeg_NAME} 
                        ${tiff_NAME} ${libpng_NAME} ${freetype_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${vtk_URL}
    URL_MD5             ${vtk_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${vtk_SRC_DIR}
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DVTK_USE_CHARTS:BOOL=ON
        -DVTK_USE_GEOVIS:BOOL=ON
        -DVTK_USE_INFOVIS:BOOL=ON
        -DVTK_USE_QT:BOOL=ON
        -DVTK_USE_QVTK_QTOPENGL:BOOL=ON
        -DVTK_USE_RENDERING:BOOL=ON
        -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
        -DVTK_USE_SYSTEM_HDF5:BOOL=ON
        -DVTK_USE_SYSTEM_JPEG:BOOL=ON
        -DVTK_USE_SYSTEM_PNG:BOOL=ON
        -DVTK_USE_SYSTEM_TIFF:BOOL=ON
        -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
        -DVTK_WRAP_PYTHON:BOOL=ON
        -DVTK_WRAP_PYTHON_SIP:BOOL=ON
        -DVTK_WRAP_TCL:BOOL=OFF
        -DNETCDF_ENABLE_NETCDF4:BOOL=ON
        -DHDF5_DIR:PATH=${ILASTIK_DEPENDENCY_DIR}/cmake/hdf5
        -DHDF5_hdf5_LIBRARY:FILEPATH=${ILASTIK_DEPENDENCY_DIR}/lib/hdf5dll.lib
        -DHDF5_hdf5_hl_LIBRARY:FILEPATH=${ILASTIK_DEPENDENCY_DIR}/lib/hdf5_hldll.lib
        -DQT_QMAKE_EXECUTABLE:FILEPATH=${QMAKE_PATH}/qmake.exe
        -DVTK_INSTALL_QT_DIR:STRING=/Qt4
        -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY_FILE}
        -DVTK_PYTHON_SETUP_ARGS:STRING=--prefix=${PYTHON_PREFIX_SLASH}
        -DSIP_EXECUTABLE:FILEPATH=${PYTHON_PREFIX}/sip.exe
        -DSIP_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DSIP_PYQT_DIR:PATH=${PYTHON_PREFIX}/sip/PyQt4
    BUILD_COMMAND       devenv VTK.sln /build Release /project INSTALL
    TEST_COMMAND        ""
    INSTALL_COMMAND     "" # devenv VTK.sln /build Release /project INSTALL
)

set_target_properties(${vtk_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vtk_NAME)