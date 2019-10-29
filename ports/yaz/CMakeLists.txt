cmake_minimum_required(VERSION 3.8)
project(yaz C)

find_package(libxml2 REQUIRED)
find_package(libxslt REQUIRED)
find_package(unofficial-iconv REQUIRED)

get_filename_component(LIB_DIRECTORY ${LIBXML2_LIBRARIES} DIRECTORY)
set(STEMMER_LIBRARIES "${LIB_DIRECTORY}/stemmer.lib")
#set(ICU_LIBRARIES "${LIB_DIRECTORY}/icudt.lib ${LIB_DIRECTORY}/icuin.lib ${LIB_DIRECTORY}/icuio.lib ${LIB_DIRECTORY}/icutu.lib ${LIB_DIRECTORY}/icuuc.lib")

file(GLOB SOURCES src/*.c)

add_compile_definitions(YAZ_HAVE_XML2=1)
include_directories(${LIBXML2_INCLUDE_DIRS})

add_compile_definitions(YAZ_HAVE_XSLT=1)
include_directories(${LIBXSLT_INCLUDE_DIR})

add_compile_definitions(HAVE_ICONV_H=1)

add_compile_definitions(YAZ_HAVE_ICU=1)
add_compile_definitions(YAZ_DLL)
add_compile_definitions(_CRT_SECURE_NO_DEPRECATE _CRT_NONSTDC_NO_DEPRECATE)

include_directories(include)
get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
add_library(yaz ${SOURCES})
target_link_libraries(yaz PRIVATE
    ${LIBXML2_LIBRARIES}
    ${LIBXSLT_LIBRARIES}
    ${ICU_LIBRARIES}
    ${STEMMER_LIBRARIES}
    unofficial::iconv::libcharset unofficial::iconv::libiconv
    ws2_32
)

install(TARGETS yaz
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)