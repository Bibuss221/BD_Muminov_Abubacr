#include "AdminPage.h"

#include "controllers/admin/AdminController.h"

#include <QLabel>
#include <QVBoxLayout>

AdminPage::AdminPage(QWidget* parent)
    : QWidget(parent)
    , description_(new QLabel(this))
{
    auto* layout = new QVBoxLayout(this);

    description_->setWordWrap(true);
    description_->setText(
        AdminController(this).roleDescription());

    layout->addWidget(description_);
    layout->addStretch();
}
