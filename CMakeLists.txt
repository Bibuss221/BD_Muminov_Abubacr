cmake_minimum_required(VERSION 3.22)
project(RentalCarSystem VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets Sql Test)

add_executable(RentalCarSystem
    app/main.cpp
    app/resources/resources.qrc
    app/resources/style.qss

    models/common/DateRules.h
    models/database/DatabaseManager.h
    models/database/DatabaseManager.cpp
    models/rental/RentalModels.h

    controllers/AuthController.h
    controllers/AuthController.cpp
    controllers/RentalController.h
    controllers/RentalController.cpp

    views/LoginWindow.h
    views/LoginWindow.cpp
    views/MainWindow.h
    views/MainWindow.cpp
)

target_include_directories(RentalCarSystem PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(RentalCarSystem PRIVATE
    Qt6::Widgets
    Qt6::Sql
)

set_target_properties(RentalCarSystem PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

enable_testing()
add_subdirectory(tests)
