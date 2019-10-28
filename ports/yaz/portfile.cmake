include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO indexdata/yaz
    REF  v5.27.2
    SHA512 b337d537271bc6303f7fa571a60b36017c1913e3826f62f3572da1fb50964e2fc974733c99c1f7ed27858ff01896e86422aba6be84b141f86f2d4f5e7831f43c
    HEAD_REF master
    PATCHES
        0002-Remove-TCL.patch
        0003-Remove-ICU.patch
        0004-Remove-libxslt-and-libxml2-dir.patch
)

find_package(LIBXML2 REQUIRED)

vcpkg_execute_required_process(
    COMMAND ${NMAKE} /f makefile LIBXSLT_DIR=${LIBXSLT_LIB} LIBXML2_DIR=${LIBXML2_LIB}
    WORKING_DIRECTORY ${SOURCE_PATH}/win
    LOGNAME build-${TARGET_TRIPLET}-rel
)