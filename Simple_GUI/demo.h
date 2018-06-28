#ifndef DEMO_H
#define DEMO_H

#include <QWidget>

namespace Ui {
class Demo;
}

class Demo : public QWidget
{
    Q_OBJECT

public:
    explicit Demo(QWidget *parent = 0);
    ~Demo();


//自定义信号
signals:
    void sigShowText(const QString&);

//自定义槽
public slots:
    //void sltLineEditChanged(const QString& text);
    void sltButtonClicked(void);        //按钮1为配准的百分比确定键
    void sltSliderMoved(int IntVal);    //滑动条1为配准百分比滑动条

private slots:
    void on_pushButton_3_clicked();

    void on_pushButton_2_clicked();

private:
    Ui::Demo *ui;
};

#endif // DEMO_H
