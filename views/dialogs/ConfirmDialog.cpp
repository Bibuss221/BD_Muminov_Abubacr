#include "ConfirmDialog.h"
bool ConfirmDialog::ask(QWidget*p,const QString&t){return QMessageBox::question(p,"Подтверждение",t,QMessageBox::Yes|QMessageBox::No)==QMessageBox::Yes;}
