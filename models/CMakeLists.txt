add_library(rental_domain STATIC
 common/DateRules.h common/DateRules.cpp
 common/Validation.h common/Validation.cpp
 common/Config.h common/Config.cpp
 database/DatabaseManager.h database/DatabaseManager.cpp
 database/RepositoryBase.h database/RepositoryBase.cpp
 clients/ClientRepository.h clients/ClientRepository.cpp
 cars/CarRepository.h cars/CarRepository.cpp
 deals/DealRepository.h deals/DealRepository.cpp
 discounts/DiscountRepository.h discounts/DiscountRepository.cpp
 penalties/PenaltyRepository.h penalties/PenaltyRepository.cpp
 reports/ReportRepository.h reports/ReportRepository.cpp
 auth/AuthService.h auth/AuthService.cpp
)
target_include_directories(rental_domain PUBLIC "${CMAKE_SOURCE_DIR}")
target_link_libraries(rental_domain PUBLIC Qt6::Core Qt6::Sql)
