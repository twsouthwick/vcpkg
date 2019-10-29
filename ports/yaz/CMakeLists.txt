cmake_minimum_required(VERSION 3.8)
project(yaz C)

option(INSTALL_HEADERS "Install public header files" ON)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

find_package(libxml2 REQUIRED)
find_package(libxslt REQUIRED)

file(GLOB SOURCES src/*.c)

add_compile_definitions(YAZ_HAVE_XML2=1)
include_directories(${LIBXML2_INCLUDE_DIRS})

add_compile_definitions(YAZ_HAVE_XSLT=1)
include_directories(${LIBXSLT_INCLUDE_DIR})

add_compile_definitions(HAVE_ICONV_H=0)

add_compile_definitions(YAZ_HAVE_ICU=0)

add_compile_definitions(_CRT_SECURE_NO_DEPRECATE _CRT_NONSTDC_NO_DEPRECATE)

include_directories(include)

target_link_libraries(libxml2 PRIVATE
    ${LIBXML2_LIBRARIES}
)

add_library(yaz ${SOURCES})

install(TARGETS yaz
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)