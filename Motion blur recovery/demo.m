clear;clc;
%��ȡ�Ҷ�ͼƬ
I=imread('test3.bmp');  
%��ͼƬ��������ת��Ϊdouble��
I=im2double(I);
%�����˶�ģ���Ƕ�
theta=ang(I);
%�����˶�ģ������
len=lenth_d(I,theta);
%�����˶�ģ���ˣ�PSF��
filt = fspecial('motion',len,theta);
%�����ģ��ͼ��
subplot(121); imshow([I]);
title('input');
%��Լ����С���˷��˲���ԭͼ��
lucy_dI=deconvreg(I,filt,20,0.05);
subplot(122); imshow([lucy_dI]);
title('deconv');

