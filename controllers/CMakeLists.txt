add_library(rental_controllers STATIC
 common/ControllerBase.h common/ControllerBase.cpp
 auth/AuthController.h auth/AuthController.cpp
 clients/ClientController.h clients/ClientController.cpp
 cars/CarController.h cars/CarController.cpp
 deals/DealController.h deals/DealController.cpp
 admin/AdminController.h admin/AdminController.cpp
 dashboard/DashboardController.h dashboard/DashboardController.cpp
)
target_include_directories(rental_controllers PUBLIC "${CMAKE_SOURCE_DIR}")
target_link_libraries(rental_controllers PUBLIC rental_domain Qt6::Core)
