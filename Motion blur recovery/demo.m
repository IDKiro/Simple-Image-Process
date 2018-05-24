clear;clc;
%读取灰度图片
I=imread('test3.bmp');  
%将图片数据类型转换为double型
I=im2double(I);
%计算运动模糊角度
theta=ang(I);
%计算运动模糊长度
len=lenth_d(I,theta);
%生成运动模糊核（PSF）
filt = fspecial('motion',len,theta);
%输入的模糊图像
subplot(121); imshow([I]);
title('input');
%用约束最小二乘方滤波复原图像
lucy_dI=deconvreg(I,filt,20,0.05);
subplot(122); imshow([lucy_dI]);
title('deconv');

