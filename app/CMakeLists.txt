qt_add_executable(RentalCarSystem WIN32
    main.cpp
    resources/resources.qrc
)
target_link_libraries(RentalCarSystem PRIVATE rental_ui)
target_include_directories(RentalCarSystem PRIVATE "${CMAKE_SOURCE_DIR}")
