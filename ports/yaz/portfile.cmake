include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO indexdata/yaz
    REF  v5.27.2
    SHA512 b337d537271bc6303f7fa571a60b36017c1913e3826f62f3572da1fb50964e2fc974733c99c1f7ed27858ff01896e86422aba6be84b141f86f2d4f5e7831f43c
    HEAD_REF master
    PATCHES
        0001-Update-version.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

#find_program (TCLSH tclsh REQUIRED)
set(TCLSH "C:\\Program Files\\Git\\mingw64\\bin\\tclsh.exe")

list(APPEND ZTCL 
    "z3950v3"
    "esupdate" # New Update extended service
    "esadmin" # Admin extended service
    "datetime" # Date extensions
    "univres" # UNIverse extension
    "charneg-3" # Charset negotiation
    "mterm2" # UserInfoFormat-multipleSearchTerms-2
    "oclcui" # UserInfoFormat-multipleSearchTerms-2
    "facet" # UserInfoFormat-facet-1
)

foreach(asn_file IN LISTS ZTCL)
    vcpkg_execute_required_process(
        COMMAND ${TCLSH} ../util/yaz-asncomp -I../include -i yaz -d z.tcl ${asn_file}.asn
        WORKING_DIRECTORY ${SOURCE_PATH}/src
        LOGNAME tcl-${asn_file}-${TARGET_TRIPLET}-rel
    )
endforeach(asn_file)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} oidtoc.tcl ${SOURCE_PATH}/src oid.csv oid_std.c oid_std.h
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-oid-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} csvtodiag.tcl srw.csv diagsrw.c ${SOURCE_PATH}/include/yaz/diagsrw.h srw
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-csvtodiag-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} csvtosru_update.tcl .
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-csvtosru_update-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} csvtodiag.tcl bib1.csv diagbib1.c ${SOURCE_PATH}/include/yaz/diagbib1.h bib1 diagbib1_str
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-diagbib1-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} ../util/yaz-asncomp -d ill.tcl -i yaz -I../include ill9702.asn
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-ill-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} ../util/yaz-asncomp -d ill.tcl -i yaz -I../include oclc-ill-req-ext.asn
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-oclc-ill-req-ext-${TARGET_TRIPLET}-rel
)

vcpkg_execute_required_process(
    COMMAND ${TCLSH} ../util/yaz-asncomp -d ill.tcl -i yaz -I../include item-req.asn
    WORKING_DIRECTORY ${SOURCE_PATH}/src
    LOGNAME tcl-item-req-${TARGET_TRIPLET}-rel
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DPORT_DIR=${CMAKE_CURRENT_LIST_DIR}
    OPTIONS_DEBUG -DINSTALL_HEADERS=OFF
)

vcpkg_install_cmake()