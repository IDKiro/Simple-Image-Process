#ifndef AGREEDIALOG_H
#define AGREEDIALOG_H

#include <QDialog>

namespace Ui {
class AgreeDialog;
}

class AgreeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit AgreeDialog(QWidget *parent = 0);
    ~AgreeDialog();


private:
    Ui::AgreeDialog *ui;
};

#endif // AGREEDIALOG_H
