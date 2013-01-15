#
# Install sqlite from source
#

if (NOT sqlite_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

# SET(sqlite_CONFIG ${ILASTIK_DEPENDENCY_DIR}/tmp/sqlite_config.cmake)
# FILE(WRITE   ${sqlite_CONFIG} "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)\n")
# FILE(APPEND  ${sqlite_CONFIG} "project (sqlite3)\n")
# FILE(APPEND  ${sqlite_CONFIG} "ADD_LIBRARY(sqlite3 STATIC shell.c sqlite3.c)\n")
# FILE(APPEND  ${sqlite_CONFIG} "INSTALL(TARGETS sqlite3 RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)\n")
# FILE(APPEND  ${sqlite_CONFIG} "INSTALL(FILES sqlite3.h sqlite3ext.h DESTINATION include)\n")

external_source (sqlite
    # 3.7.15
    3.6.21 # version number is hard-wirde in Python project files
           # FIXME: patch those project files
    sqlite-amalgamation-3071502.zip
    7f95fd6b0d69a9773ef0258e9f4f3035
    http://www.sqlite.org/
    FORCE)

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
message ("Installing ${sqlite_NAME} into ilastik build area: ${ILASTIK_DEPENDENCY_DIR} ...")
ExternalProject_Add(${sqlite_NAME}
    PREFIX              ${ILASTIK_DEPENDENCY_DIR}
    URL                 ${sqlite_URL}
    URL_MD5             ${sqlite_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

set_target_properties(${sqlite_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sqlite_NAME)