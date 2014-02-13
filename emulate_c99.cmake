#
# Install emulate_c99 from source
#

if (NOT emulate_c99_NAME)

set(emulate_c99_NAME emulate_c99)
set(emulate_c99_SRC_DIR "${PROJECT_SOURCE_DIR}/emulate_c99")
    
message ("Installing ${emulate_c99_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${emulate_c99_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    SOURCE_DIR          ${emulate_c99_SRC_DIR} 
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${emulate_c99_SRC_DIR} 
        -G ${CMAKE_GENERATOR} 
        -DCMAKE_INSTALL_PREFIX=${ILASTIK_DEPENDENCY_DIR}
    BUILD_COMMAND       devenv emulate_c99.sln /build Release /project emulate_c99
    INSTALL_COMMAND     devenv emulate_c99.sln /build Release /project INSTALL
)

set_target_properties(${emulate_c99_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT emulate_c99_NAME)
