#include "demo.h"
#include "agreedialog.h"
#include <QApplication>
//#include <QPushButton>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    AgreeDialog agd;                    //不知道为什么主程序中创建窗口必须是变量
    int ret = agd.exec();
    if (ret == AgreeDialog::Rejected)
    {
        return app.exec();
    }

    Demo demo;
    demo.show();

   //创建子窗口按钮
    /*
    QPushButton ButtonWindows1;
    ButtonWindows1.setText("创建子框口按钮1");
    ButtonWindows1.show();
    ButtonWindows1.resize(200, 100);
    */

    return app.exec();
}
