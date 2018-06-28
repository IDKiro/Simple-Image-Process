clear; clc; clf;

% ��ȡ�Ҷ�ͼƬ
f = rgb2gray(imread('test_blur.jpg'));

% ��ͼƬ��������ת��Ϊdouble��

I = im2double(f);

% �����˶�ģ���Ƕ�
theta = ang(I);

% �����˶�ģ������
len = lenth_d(I, 35);

% �����˶�ģ���ˣ�PSF��
filt = fspecial('motion', len, theta);

% �����ģ��ͼ��
subplot(1, 2, 1), imshow([I]), title('����ͼ��');

% ��Լ����С���˷��˲���ԭͼ��
lucy_dI = deconvreg(I, filt, 20, 0.05);
subplot(1, 2, 2), imshow([lucy_dI]), title('��ԭͼ��');
