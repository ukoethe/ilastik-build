#
# Install pil library from source
#

if (NOT pil_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)
include (numpy)
include (jpeg)
include (tiff)
include (png)
include (freetype)

external_source (pil
    1.1.7
    Imaging-1.1.7.tar.gz
    fc14a54e1ce02a0225be8854bfba478e
    http://effbot.org/downloads
    FORCE)

# Fix library and path names in setup.py
set (pil_PATCH ${PYTHON_EXE} ${PROJECT_SOURCE_DIR}/patches/patch_pil.py ${pil_SRC_DIR} ${ILASTIK_DEPENDENCY_DIR})

message ("Installing ${pil_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${pil_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${jpeg_NAME} ${png_NAME} ${tiff_NMAE} ${freetype_NMAE}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${pil_URL}
    URL_MD5             ${pil_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${pil_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${PYTHON_EXE} setup.py build_ext -c msvc
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${PYTHON_EXE} setup.py install
)

set_target_properties(${pil_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pil_NAME)
