clear;clc;

%读取图片，并预处理
I=imread('sample.bmp'); 
I = rgb2gray(I);
RADIUS = 8;
H = fspecial('disk',RADIUS);   %圆盘模糊核，半径为8
BI = imfilter(I,H);
BI=im2double(BI);
BI = BI(11:490,11:490);   %截取图像，减少计算量并消去周围黑边现象
figure, imshow(BI), title('Blurred Img')

%估计圆盘模糊核半径
radius = estRadius(BI); 
err = abs(RADIUS-radius)/RADIUS;
fprintf('The true radius：%.2f, the estimated radius: %.2f, the relative error: %.2f%% ', RADIUS, radius, err);

%用Lucy-Richardson简单地重建清晰图像
h = fspecial('disk',radius );
BI = edgetaper(BI, h);   %边缘预处理
DeBI=deconvlucy(BI,h,100);
figure, imshow(DeBI), title('Deblurred Img')
