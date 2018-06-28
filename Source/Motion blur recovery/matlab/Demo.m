clear; clc; clf;

% 读取灰度图片
f = rgb2gray(imread('test_blur.jpg'));

% 将图片数据类型转换为double型

I = im2double(f);

% 计算运动模糊角度
theta = ang(I);

% 计算运动模糊长度
len = lenth_d(I, 35);

% 生成运动模糊核（PSF）
filt = fspecial('motion', len, theta);

% 输入的模糊图像
subplot(1, 2, 1), imshow([I]), title('输入图像');

% 用约束最小二乘方滤波复原图像
lucy_dI = deconvreg(I, filt, 20, 0.05);
subplot(1, 2, 2), imshow([lucy_dI]), title('复原图像');
