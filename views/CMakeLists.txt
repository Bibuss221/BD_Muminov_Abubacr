add_library(rental_ui STATIC
    common/TablePage.h
    common/TablePage.cpp

    dialogs/ConfirmDialog.h
    dialogs/ConfirmDialog.cpp

    auth/LoginWindow.h
    auth/LoginWindow.cpp

    dashboard/MainWindow.h
    dashboard/MainWindow.cpp

    clients/ClientPage.h
    clients/ClientPage.cpp

    cars/CarPage.h
    cars/CarPage.cpp

    deals/DealPage.h
    deals/DealPage.cpp

    discounts/DiscountPage.h
    discounts/DiscountPage.cpp

    penalties/PenaltyPage.h
    penalties/PenaltyPage.cpp

    reports/ReportPage.h
    reports/ReportPage.cpp

    admin/AdminPage.h
    admin/AdminPage.cpp
)

target_include_directories(rental_ui PUBLIC
    "${CMAKE_SOURCE_DIR}"
)

target_link_libraries(rental_ui PUBLIC
    rental_controllers
    Qt6::Widgets
)
