cmake_minimum_required(VERSION 3.20)

project(project_name)

set(CMAKE_CXX_STANDARD 23)

add_subdirectory(src)

install(TARGETS project_name DESTINATION bin)
