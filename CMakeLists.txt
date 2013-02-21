CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
project (ilastik)

include (ExternalProject)

############################################################################
# Check if ILASTIK_DEPENDENCY_DIR has already been assigned.  If not, create a default.

find_package(git REQUIRED)

get_filename_component(GIT_PATH ${GIT_EXECUTABLE} PATH)
get_filename_component(PATCH_EXE ${GIT_PATH}/../bin/patch.exe ABSOLUTE)
    
if(NOT EXISTS ${PATCH_EXE})
    message(FATAL_ERROR "patch.exe NOT found, should be at \n${PATCH_EXE}")
endif()

set (ILASTIK_DEPENDENCY_DIR "None" CACHE TYPE STRING)
if (${ILASTIK_DEPENDENCY_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: ILASTIK_DEPENDENCY_DIR build directory (for all downloads & builds) should be specified via -DILASTIK_DEPENDENCY_DIR=<path> on cmake command line.")
endif ()
get_filename_component(ILASTIK_DEPENDENCY_DIR ${ILASTIK_DEPENDENCY_DIR} ABSOLUTE)

set (MSYS_PATH "None" CACHE TYPE STRING)
if (${MSYS_PATH} STREQUAL "None")
    message (FATAL_ERROR "ERROR: MSYS_PATH must be specified via -DMSYS_PATH=<path> on cmake command line.")
endif ()
get_filename_component(MSYS_PATH ${MSYS_PATH} ABSOLUTE)

set (MINGW_PATH "None" CACHE TYPE STRING)
if (${MINGW_PATH} STREQUAL "None")
    message (FATAL_ERROR "ERROR: MINGW_PATH must be specified via -DMINGW_PATH=<path> on cmake command line.")
endif ()
get_filename_component(MINGW_PATH ${MINGW_PATH} ABSOLUTE)

message ("ilastik downloads and builds will be placed here: ${ILASTIK_DEPENDENCY_DIR}")

FILE(MAKE_DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/bin 
                    ${ILASTIK_DEPENDENCY_DIR}/lib 
                    ${ILASTIK_DEPENDENCY_DIR}/include
                    ${ILASTIK_DEPENDENCY_DIR}/ilastik
                    ${ILASTIK_DEPENDENCY_DIR}/tmp )

file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}     ILASTIK_INSTALL_PATH)
file(TO_NATIVE_PATH ${ILASTIK_DEPENDENCY_DIR}/bin ILASTIK_BIN_PATH)

############################################################################

SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  ${ilastik_SOURCE_DIR})

include(python)
include(python_packages)
include(openblas)
include(numpy)
include(scipy)
include(zlib)
include(jpeg)
include(tiff)
include(libpng)
include(fftw)
include(hdf5)
include(h5py)
include(boost)
include(vigra)
include(qt)
include(pyqt)
include(qimage2ndarray)
include(vigraqt)
include(freetype)
include(matplotlib)
include(lemon)
include(cylemon)



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

configure_file(pixelClassification.bat.in ${ILASTIK_DEPENDENCY_DIR}/pixelClassification.bat)

file(TO_NATIVE_PATH " ${ILASTIK_DEPENDENCY_DIR}/bin ${QT_BUILD_DIR}/bin ${PYTHON_PREFIX} ${PYTHON_PREFIX}/Scripts" ILASTIK_PATH_SETTINGS)

# APP_DEPENDENCIES is auto-generated by the above includes and holds all included targets.
ADD_CUSTOM_TARGET(ilastik DEPENDS ${APP_DEPENDENCIES}
                  COMMENT "Installed ilastik dependencies. Add directories to your PATH variable: ${ILASTIK_PATH_SETTINGS}")

install(CODE "execute_process(COMMAND ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/compile_all.py ${ILASTIK_DEPENDENCY_DIR}/ilastik)")
INSTALL(FILES ${ILASTIK_DEPENDENCY_DIR}/pixelClassification.bat DESTINATION .)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/ilastik/ DESTINATION ilastik)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/bin/ DESTINATION bin FILES_MATCHING PATTERN "*.dll")
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/python/ DESTINATION python PATTERN "*ui-bg_highlight-soft_75_cccccc_1x100.png" EXCLUDE)
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/Qt4/bin/ DESTINATION Qt4/bin FILES_MATCHING PATTERN "*.dll")
INSTALL(DIRECTORY ${ILASTIK_DEPENDENCY_DIR}/Qt4/plugins/ DESTINATION Qt4/plugins FILES_MATCHING PATTERN "*.dll")

SET(CPACK_PACKAGE_VENDOR "Heidelberg Collaboratory for Image Processing")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Interactive image labeling and segmentation toolkit."
)

# package version setup
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "6")
SET(CPACK_PACKAGE_VERSION_PATCH "a")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY     "${PROJECT_NAME}-0.6.a")

# cannot use SET(CPACK_PACKAGE_EXECUTABLES ...) for *.bat files because it appends .exe
string(REGEX REPLACE "/" "\\\\\\\\" ILASTIK_SHORTCUT_ICON "${PROJECT_SOURCE_DIR}/ilastik-icon.ico")
SET(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
  CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Pixel Classification.lnk\\\" \\\"$INSTDIR\\\\pixelClassification.bat\\\" \\\"\\\" \\\"${ILASTIK_SHORTCUT_ICON}\\\"
")
SET(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
  !insertmacro MUI_STARTMENU_GETFOLDER Application $STARTMENU_FOLDER
  Delete \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Pixel Classification.lnk\\\"
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
