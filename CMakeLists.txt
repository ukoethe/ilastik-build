CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
project (ilastik)

# check that cmake generator and compiler path in the shell are consistent
execute_process(COMMAND where cl.exe
                  OUTPUT_VARIABLE CL_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
FILE(TO_CMAKE_PATH ${CL_PATH} CL_PATH)

STRING(REGEX REPLACE "/VC/bin/.*" "" VISUAL_STUDIO_PATH ${CL_PATH})
STRING(REGEX REPLACE "/VC/bin/.*" "" CMAKE_VISUAL_STUDIO_PATH ${CMAKE_C_COMPILER})
string(TOLOWER ${VISUAL_STUDIO_PATH} VSPATH_LOWER)
string(TOLOWER ${CMAKE_VISUAL_STUDIO_PATH} CMAKE_VSPATH_LOWER)

if(NOT "${VSPATH_LOWER}" STREQUAL "${CMAKE_VSPATH_LOWER}")
   MESSAGE(FATAL_ERROR "Mismatch between generator (-G) and shell:\n  generator uses '${CMAKE_VISUAL_STUDIO_PATH}'\n  shell uses '${VISUAL_STUDIO_PATH}'")
endif()

if(NOT "${CL_PATH}" MATCHES "amd64")
    MESSAGE(FATAL_ERROR "Compiler must be 64-bit, but shell uses\n  '${CL_PATH}'")
endif()

if(NOT "${CMAKE_C_COMPILER}" MATCHES "amd64")
    MESSAGE(FATAL_ERROR "Compiler must be 64-bit, but generator uses\n  '${CMAKE_C_COMPILER}'")
endif()

# find compiler version
STRING(REGEX MATCH "Studio [0-9]+" VISUAL_STUDIO_VERSION ${VISUAL_STUDIO_PATH})
STRING(REGEX REPLACE "Studio " "" VISUAL_STUDIO_VERSION ${VISUAL_STUDIO_VERSION})
MESSAGE(STATUS "Using Visual Studio ${VISUAL_STUDIO_VERSION} at '${VISUAL_STUDIO_PATH}'")

include (ExternalProject)

find_package(git REQUIRED)

get_filename_component(GIT_PATH ${GIT_EXECUTABLE} PATH)
get_filename_component(PATCH_EXE ${GIT_PATH}/../bin/patch.exe ABSOLUTE)
    
if(NOT EXISTS ${PATCH_EXE})
    message(FATAL_ERROR "patch.exe NOT found, should be at \n${PATCH_EXE}")
endif()

find_package(perl REQUIRED)
GET_FILENAME_COMPONENT(PERL_PATH ${PERL_EXECUTABLE} ABSOLUTE)
file(TO_NATIVE_PATH ${PERL_PATH} PERL_PATH)

set (ILASTIK_DEPENDENCY_DIR "None" CACHE PATH "Install prefix for ilastik and its dependencies.")
if (${ILASTIK_DEPENDENCY_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: ILASTIK_DEPENDENCY_DIR build directory (for all downloads & builds) should be specified via -DILASTIK_DEPENDENCY_DIR=<path> on the cmake command line.")
endif ()
get_filename_component(ILASTIK_DEPENDENCY_DIR ${ILASTIK_DEPENDENCY_DIR} ABSOLUTE)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR} ILASTIK_DEPENDENCY_DIR_DOS)

OPTION(WITH_SCIPY "Build scipy (and its dependencies) ?" OFF)

if(WITH_SCIPY)
    set (MSYS_PATH "-NOTFOUND" CACHE PATH "Path to MSYS binaries (must contain make.exe).")
    set (MINGW_PATH "-NOTFOUND" CACHE PATH "Path to MinGW binaries (must contain gfortran.exe).")
    
    if (${MSYS_PATH} STREQUAL "-NOTFOUND" OR ${MINGW_PATH} STREQUAL "-NOTFOUND")
        message (FATAL_ERROR "ERROR: To build scipy, MSYS_PATH and MINGW_PATH must be specified via -DMSYS_PATH=<path> -DMINGW_PATH=<path> on the cmake command line.")
    endif ()

    get_filename_component(MSYS_PATH ${MSYS_PATH} ABSOLUTE)
    file(TO_NATIVE_PATH ${MSYS_PATH} MSYS_PATH)
    get_filename_component(MINGW_PATH ${MINGW_PATH} ABSOLUTE)
    file(TO_NATIVE_PATH ${MINGW_PATH} MINGW_PATH)
endif()

OPTION(WITH_VTK "Build VTK ?" OFF)
OPTION(WITH_PGMLINK "pgmLink requires an installed cplex to build successfully" OFF)

message ("ilastik downloads and builds will be placed here: ${ILASTIK_DEPENDENCY_DIR}")

FILE(MAKE_DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/bin 
                    ${ILASTIK_DEPENDENCY_DIR}/lib 
                    ${ILASTIK_DEPENDENCY_DIR}/include
                    ${ILASTIK_DEPENDENCY_DIR}/ilastik
                    ${ILASTIK_DEPENDENCY_DIR}/tmp )

file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}     ILASTIK_INSTALL_PATH)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/bin ILASTIK_BIN_PATH)

set(ADD_PATH "${ILASTIK_DEPENDENCY_DIR}/tmp/add_path.bat")
configure_file(add_path.bat ${ADD_PATH} COPYONLY)

############################################################################

SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  ${ilastik_SOURCE_DIR})

include(openssl)
include(python)
include(python_packages)
include(numpy)
include(zlib)
include(jpeg)
include(tiff)
include(libpng)
include(fftw)
include(hdf5)
include(h5py)
include(boost)
include(vigra)
include(pil)
include(qt)
include(pyqt)
include(qimage2ndarray)
include(vigraqt)
include(freetype)
include(matplotlib)
include(lemon)
include(cylemon)
include(spyder)

if(WITH_SCIPY)
    include(scipy)
    include(scikit_learn)
    include(scikit_image)
endif()
if(WITH_VTK)
    include(vtk)
endif()
if(WITH_PGMLINK) 
    include(ann)
    include(opengm)
    include(pgmlink)
endif()

#############################################################################

if (NOT lazyflow_NAME)

set(lazyflow_NAME lazyflow-HEAD)

message ("Installing ${lazyflow_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/ilastik ...")
ExternalProject_Add(${lazyflow_NAME}
    DEPENDS             ${python_NAME} ${vigra_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    DOWNLOAD_DIR        ${ILASTIK_DEPENDENCY_DIR}/ilastik
    SOURCE_DIR          ${ILASTIK_DEPENDENCY_DIR}/ilastik/lazyflow
    GIT_REPOSITORY      https://github.com/ilastik/lazyflow.git
    PATCH_COMMAND       ""
    BINARY_DIR          ${ILASTIK_DEPENDENCY_DIR}/src/drtile-build
    # Read the config information from ${ILASTIK_DEPENDENCY_DIR}/lib/vigranumpy/VigranumpyConfig.cmake
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${ILASTIK_DEPENDENCY_DIR}/ilastik/lazyflow/lazyflow/drtile
        -G ${CMAKE_GENERATOR}
        -DVigranumpy_DIR=${ILASTIK_DEPENDENCY_DIR}/lib/vigranumpy
    BUILD_COMMAND       devenv drtile.sln /build "Release" /project drtile
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy Release/drtile.pyd ${ILASTIK_DEPENDENCY_DIR}/ilastik/lazyflow/lazyflow/drtile
)

set_target_properties(${lazyflow_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${lazyflow_NAME})

endif (NOT lazyflow_NAME)

#############################################################################

if (NOT volumina_NAME)

set(volumina_NAME volumina-HEAD)

message ("Installing ${volumina_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/ilastik ...")
ExternalProject_Add(${volumina_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    DOWNLOAD_DIR        ${ILASTIK_DEPENDENCY_DIR}/ilastik
    SOURCE_DIR          ${ILASTIK_DEPENDENCY_DIR}/ilastik/volumina
    GIT_REPOSITORY      https://github.com/ilastik/volumina.git
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
    BUILD_IN_SOURCE     1
)

set_target_properties(${volumina_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${volumina_NAME})

endif (NOT volumina_NAME)

#############################################################################

if (NOT ilastik_NAME)

set(ilastik_NAME ilastik-HEAD)

message ("Installing ${ilastik_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR}/ilastik ...")
ExternalProject_Add(${ilastik_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    DOWNLOAD_DIR        ${ILASTIK_DEPENDENCY_DIR}/ilastik
    SOURCE_DIR          ${ILASTIK_DEPENDENCY_DIR}/ilastik/ilastik
    GIT_REPOSITORY      https://github.com/ilastik/ilastik.git
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
    BUILD_IN_SOURCE     1
)

set_target_properties(${ilastik_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${ilastik_NAME})

endif (NOT ilastik_NAME)

############################################################################

configure_file(ilastik.bat.in ${ILASTIK_DEPENDENCY_DIR}/ilastik.bat)
configure_file(ilastik-icon.ico ${ILASTIK_DEPENDENCY_DIR}/ilastik-icon.ico COPYONLY)

file(TO_NATIVE_PATH " ${ILASTIK_DEPENDENCY_DIR}/bin ${QT_BUILD_DIR}/bin ${PYTHON_PREFIX} ${PYTHON_PREFIX}/Scripts" ILASTIK_PATH_SETTINGS)

# APP_DEPENDENCIES is auto-generated by the above includes and holds all included targets.
ADD_CUSTOM_TARGET(ilastik DEPENDS ${APP_DEPENDENCIES}
                  COMMENT "Installed ilastik dependencies. Add directories to your PATH variable: ${ILASTIK_PATH_SETTINGS}")

install(CODE "execute_process(COMMAND ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/compile_all.py ${ILASTIK_DEPENDENCY_DIR}/ilastik)")
INSTALL(FILES ${ILASTIK_DEPENDENCY_DIR}/ilastik-icon.ico DESTINATION .)
INSTALL(FILES ${ILASTIK_DEPENDENCY_DIR}/ilastik.bat DESTINATION .)
INSTALL(FILES ${ILASTIK_DEPENDENCY_DIR}/spyder.bat DESTINATION .)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/ilastik/ DESTINATION ilastik)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/bin/ DESTINATION bin FILES_MATCHING PATTERN "*.dll")
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/python/ DESTINATION python PATTERN "*ui-bg_highlight-soft_75_cccccc_1x100.png" EXCLUDE)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/Qt4/bin/ DESTINATION Qt4/bin FILES_MATCHING PATTERN "*.dll")
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/Qt4/plugins/ DESTINATION Qt4/plugins FILES_MATCHING PATTERN "*.dll")

# OpenMP runtimes are needed for cylemon
file(TO_CMAKE_PATH "$ENV{VCINSTALLDIR}" MSVC_ROOT)
string(REGEX REPLACE "\\." "" MSVC_VERSION "$ENV{VISUALSTUDIOVERSION}")
INSTALL(DIRECTORY ${MSVC_ROOT}/redist/x64/Microsoft.VC${MSVC_VERSION}.OpenMP/ DESTINATION bin FILES_MATCHING PATTERN "vcomp*.dll")

SET(CPACK_PACKAGE_VENDOR "The ilastik Team")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Interactive image labeling and segmentation toolkit."
)

# package version setup
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "6")
SET(CPACK_PACKAGE_VERSION_PATCH "a")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY     "${PROJECT_NAME}-0.6.a")

# cannot use SET(CPACK_PACKAGE_EXECUTABLES ...) for *.bat files because it appends .exe
SET(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
  CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\ilastik.lnk\\\" \\\"$INSTDIR\\\\ilastik.bat\\\" \\\"\\\" \\\"$INSTDIR\\\\ilastik-icon.ico\\\"
  CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\spyder.lnk\\\" \\\"$INSTDIR\\\\spyder.bat\\\" \\\"\\\" \\\"$INSTDIR\\\\ilastik-icon.ico\\\"
")
SET(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
  !insertmacro MUI_STARTMENU_GETFOLDER Application $STARTMENU_FOLDER
  Delete \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\ilastik.lnk\\\"
  Delete \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\spyder.lnk\\\"
")

# Cannot use SET(CPACK_PACKAGE_ICON  ...) because NSIS needs a Windows path here.
# The icon must be a 150x57 BMP image created with Paint (gimp's BMP doesn't work).
string(REGEX REPLACE "/" "\\\\\\\\" CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/ilastik-installer.bmp")

# SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY  "${PROJECT_NAME}")
# SET(CPACK_RESOURCE_FILE_LICENSE         "${PROJECT_SOURCE_DIR}/LICENSE.txt")
# SET(CPACK_RESOURCE_FILE_README          "${PROJECT_SOURCE_DIR}/README.txt")
SET(CPACK_STRIP_FILES TRUE)
SET(CPACK_PACKAGE_CONTACT "ilastik Team <team@ilastik.org>")

INCLUDE (CPack)

MESSAGE(STATUS "Using Visual Studio ${VISUAL_STUDIO_VERSION} at '${CMAKE_C_COMPILER}'")

