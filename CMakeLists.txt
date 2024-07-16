cmake_minimum_required(VERSION 3.10)
project(rlnuklear VERSION 1.0 LANGUAGES C)

# Accept RAYLIB_DIR as an argument
if(NOT DEFINED RAYLIB_DIR)
    message(FATAL_ERROR "RAYLIB_DIR is not defined. Please specify the Raylib directory.")
endif()

# Add the library
add_library(${PROJECT_NAME} STATIC
    src/rlnuklear.c
)

# Include directories
target_include_directories(${PROJECT_NAME} PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    "${RAYLIB_DIR}/src"
)

# Print raylib include dir
message(STATUS "Raylib include dir: ${RAYLIB_DIR}/src")

# Link against Raylib
target_link_directories(${PROJECT_NAME} PUBLIC ${RAYLIB_DIR}/src)
target_link_libraries(${PROJECT_NAME} PUBLIC raylib)

# Set C standard
set_target_properties(${PROJECT_NAME} PROPERTIES
    C_STANDARD 11
    C_STANDARD_REQUIRED ON
)

# Install rules
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(FILES 
    include/nuklear.h
    include/raylib-nuklear-font.h
    include/raylib-nuklear.h
    DESTINATION include
)