function(add_rental_test name source)
    qt_add_executable(${name} ${source})

    target_link_libraries(${name}
        PRIVATE
        rental_domain
        Qt6::Test
    )

    target_include_directories(${name}
        PRIVATE
        "${CMAKE_SOURCE_DIR}"
    )

    add_test(NAME ${name} COMMAND ${name})
endfunction()

add_rental_test(tst_date_rules test_date_rules.cpp)
add_rental_test(tst_overlap_rules test_overlap_rules.cpp)
add_rental_test(tst_validation test_validation.cpp)
