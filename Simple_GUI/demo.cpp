#include <QDialog>
#include <QFileDialog>
#include <QLabel>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <string>
#include "demo.h"
#include "ui_demo.h"
#include "inputdialog.h"
#include "pixtrans.h"

using namespace std;
using namespace cv;

Demo::Demo(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Demo)
{
    ui->setupUi(this);

    this->setFixedSize(this->width(), this->height());      //禁止窗口缩放

    //修改lineEdit的显示文本
    //ui->lineEdit->setText("文本1修改1");

    int max = 100, min = 0;
    ui->horizontalSlider->setMaximum(max);
    ui->horizontalSlider->setMinimum(min);
    QIntValidator* validator = new QIntValidator(min, max, this);   //验证器验证输入数据是否为数字且在范围内
    ui->lineEdit->setValidator(validator);  //为lineEdit设置验证器

    /*输入框和滑动条的信号与槽自定义通信
    connect(ui->lineEdit, SIGNAL(textChanged(QString)), this, SLOT(sltLineEditChanged(QString))); //将lineEdit的文本改变信号传递到滑动条改变信号槽中，同时共享字符串
    connect(ui->lineEdit, &QLineEdit::textChanged, this, &Demo::sltLineEditChanged);  //上行新写法
    */

    //按钮和滑动条的信号与槽自定义通信
    connect(ui->pushButton, SIGNAL(clicked(bool)), this, SLOT(sltButtonClicked()));
    connect(ui->horizontalSlider, SIGNAL(valueChanged(int)), this, SLOT(sltSliderMoved(int)));

}

Demo::~Demo()
{
    delete ui;
}

/*
void Demo::sltLineEditChanged(const QString &text)
{
    int val = text.toInt();
    ui->horizontalSlider->setValue(val);
    emit sigShowText(text); //发送信号
}
*/

void Demo::sltButtonClicked(void)
{
    QString text = ui->lineEdit->text();    //获取文本框内的字符串
    int val = text.toInt();
    ui->horizontalSlider->setValue(val);
    emit sigShowText(text); //发送信号
}

void Demo::sltSliderMoved(int IntVal)
{
    QString text = QString::number(IntVal, 10);
    ui->lineEdit->setText(text);
}

void Demo::on_pushButton_3_clicked()
{
    InputDialog* dlg = new InputDialog(this);   //定义为指针不会闪退
    //dlg->show();                              //非模态对话框使用show()，模态对话框使用exec()
    int ret = dlg->exec();
    if (ret == InputDialog::Accepted)
    {
        ui->lineEdit_3->setText("确定");
    }
    else if (ret == InputDialog::Rejected)
    {
        ui->lineEdit_3->setText("取消");
    }
}

void Demo::on_pushButton_2_clicked()
{
    QString fileName = QFileDialog::getOpenFileName(this, tr("打开文件"), " ",  tr("图像文件(*.jpg *.png *.bmp)"));
	if (fileName == NULL)
	{
		ui->lineEdit_2->setText("请选择图像文件");
		return;
	}
    ui->lineEdit_2->setText(fileName);
    
	QGraphicsScene *scene = new QGraphicsScene;	//图像控件
	string str = fileName.toStdString();
	Mat img;
	img = imread(str); 
    QPixmap pic;
    pic = qtcv::cvMatToQPixmap(img);
	scene->addPixmap(pic);
	ui->graphicsView->setScene(scene);

	/*
	QLabel* imageLable = new QLabel(this);      //标签控件可以显示文本和图片
	imageLable->setPixmap(pic);                 //将QLable设置为显示pixmap图片
	ui->scrollArea->setWidget(imageLable);
	*/



    return;
}
