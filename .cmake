function(download_dependency_mod REPO_NAME DEPENDENCY_ID)
    set(DEPS_DIR "${CMAKE_BINARY_DIR}/geode-deps/${DEPENDENCY_ID}")
    file(MAKE_DIRECTORY "${DEPS_DIR}")
    set(DOWNLOAD_URL "https://github.com/${REPO_NAME}/releases/latest/download/${DEPENDENCY_ID}.geode")
    set(GEODE_FILE "${DEPS_DIR}/${DEPENDENCY_ID}.geode")
    message(STATUS "Downloading ${DEPENDENCY_ID} from: ${DOWNLOAD_URL}")
    file(DOWNLOAD "${DOWNLOAD_URL}" "${GEODE_FILE}" STATUS DOWNLOAD_STATUS)
    list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
    if(NOT STATUS_CODE EQUAL 0)
        message(FATAL_ERROR "Failed to download ${DEPENDENCY_ID}: ${DOWNLOAD_STATUS}")
    endif()
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xf "${GEODE_FILE}"
        WORKING_DIRECTORY "${DEPS_DIR}"
        RESULT_VARIABLE EXTRACT_RESULT
    )
    if(NOT EXTRACT_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to extract ${DEPENDENCY_ID}.geode")
    endif()
    file(REMOVE "${GEODE_FILE}")
    file(WRITE "${DEPS_DIR}/geode-dep-options.json" "{ \"required\": true }")
    message(STATUS "Successfully dependency mod: ${DEPENDENCY_ID}")
endfunction()
