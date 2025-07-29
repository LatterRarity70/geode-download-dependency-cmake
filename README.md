# geode-download-dependency-cmake
A helper CMake function that allows Geode mod developers to use dependency mods from their latest GitHub release. Useful when the dependency is not published in the official Geode index. Solution is cross-platform and supports Geode Mod Build workflows.

## Usage
```cmake
file(DOWNLOAD "https://raw.githubusercontent.com/user95401/geode-download-dependency-cmake/refs/heads/main/.cmake" 
    ${CMAKE_CURRENT_BINARY_DIR}/geode-download-dependency.cmake)
include(${CMAKE_CURRENT_BINARY_DIR}/geode-download-dependency.cmake)

download_dependency_mod(user95401/geode-game-objects-factory user95401.game-objects-factory)

setup_geode_mod(${PROJECT_NAME} EXTERNALS user95401.game-objects-factory)
```
