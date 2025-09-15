# A helper function to download Geode mod dependencies from GitHub releases
# Usage:
#   download_dependency_mod(owner/repo-name mod.id [REQUIRED])
# Example:
#   download_dependency_mod(user95401/geode-game-objects-factory user95401.game-objects-factory)
#   download_dependency_mod(user95401/geode-game-objects-factory user95401.game-objects-factory FALSE)
set(GEODE_DEPS_DIR "${CMAKE_BINARY_DIR}/geode-deps/")
function(download_dependency_mod REPO_NAME DEPENDENCY_ID)
    # Parse optional arguments
    set(REQUIRED TRUE) # Default value
    if(ARGC GREATER 2)
        set(REQUIRED ${ARGV2})
    endif()

    # Validate input parameters
    if(NOT REPO_NAME OR NOT DEPENDENCY_ID)
        message(FATAL_ERROR "download_dependency_mod: Both REPO_NAME and DEPENDENCY_ID are required")
    endif()
    
    set(DEPS_DIR "${CMAKE_BINARY_DIR}/geode-deps/${DEPENDENCY_ID}")
    set(OPTIONS_FILE "${DEPS_DIR}/geode-dep-options.json")
    
    # Check if dependency is already downloaded and extracted
    if(EXISTS "${OPTIONS_FILE}")
        message(STATUS "Dependency '${DEPENDENCY_ID}' already exists, skipping download")
        return()
    endif()
    
    # Create dependency directory
    file(MAKE_DIRECTORY "${DEPS_DIR}")
    
    # Construct download URL for latest release
    set(DOWNLOAD_URL "https://github.com/${REPO_NAME}/releases/latest/download/${DEPENDENCY_ID}.geode")
    set(GEODE_FILE "${DEPS_DIR}/${DEPENDENCY_ID}.geode")
    
    message(STATUS "Downloading dependency '${DEPENDENCY_ID}' from: ${DOWNLOAD_URL}")
    
    # Download the .geode file
    file(DOWNLOAD 
        "${DOWNLOAD_URL}" 
        "${GEODE_FILE}"
        STATUS DOWNLOAD_STATUS
    )
    
    # Check download status
    list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
    if(NOT STATUS_CODE EQUAL 0)
        list(GET DOWNLOAD_STATUS 1 ERROR_MESSAGE)
        message(FATAL_ERROR "Failed to download '${DEPENDENCY_ID}': ${ERROR_MESSAGE}")
    endif()
    
    # Extract the .geode file (it's a ZIP archive)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xf "${GEODE_FILE}"
        WORKING_DIRECTORY "${DEPS_DIR}"
        RESULT_VARIABLE EXTRACT_RESULT
        OUTPUT_QUIET
        ERROR_QUIET
    )
    
    # Check extraction status
    if(NOT EXTRACT_RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to extract '${DEPENDENCY_ID}.geode'")
    endif()
    
    # Remove the downloaded archive to avoid errors in combine workflow part
    file(REMOVE "${GEODE_FILE}")
    
    file(WRITE "${OPTIONS_FILE}" "{ \"required\": ${REQUIRED} }")
    message(STATUS "Successfully installed dependency: '${DEPENDENCY_ID}' (required: ${REQUIRED})")
endfunction()