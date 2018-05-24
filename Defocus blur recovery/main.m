clear;clc;

%��ȡͼƬ����Ԥ����
I=imread('sample.bmp'); 
I = rgb2gray(I);
RADIUS = 8;
H = fspecial('disk',RADIUS);   %Բ��ģ���ˣ��뾶Ϊ8
BI = imfilter(I,H);
BI=im2double(BI);
BI = BI(11:490,11:490);   %��ȡͼ�񣬼��ټ���������ȥ��Χ�ڱ�����
figure, imshow(BI), title('Blurred Img')

%����Բ��ģ���˰뾶
radius = estRadius(BI); 
err = abs(RADIUS-radius)/RADIUS;
fprintf('The true radius��%.2f, the estimated radius: %.2f, the relative error: %.2f%% ', RADIUS, radius, err);

%��Lucy-Richardson�򵥵��ؽ�����ͼ��
h = fspecial('disk',radius );
BI = edgetaper(BI, h);   %��ԵԤ����
DeBI=deconvlucy(BI,h,100);
figure, imshow(DeBI), title('Deblurred Img')
