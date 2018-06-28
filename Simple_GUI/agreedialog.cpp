#include "agreedialog.h"
#include "ui_agreedialog.h"

AgreeDialog::AgreeDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AgreeDialog)
{
    ui->setupUi(this);
    this->setWindowFlags(Qt::FramelessWindowHint); //无标题
}

AgreeDialog::~AgreeDialog()
{
    delete ui;
}
