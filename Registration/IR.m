clear;clf;clc;
f1 = imread('lll4.bmp');f2 = imread('lll8.bmp');% 1. ��ȡͼƬ 
subplot(2,2,1),imshow(f1,[]),title('��׼ͼ');
subplot(2,2,2),imshow(f2,[]),title('����׼ͼ');    % 2. ��ʾ��׼ͼ��
F1 = fftshift(fft2(f1));   F2 = fftshift(fft2(f2));% 3. ��ͼ����п��ٸ���Ҷ�任  
Fa1 = abs(F1); Fa2 = abs(F2);
Fb1 = highpass_filter(Fa1);Fb2 = highpass_filter(Fa2);% 4. ȡ�����ײ���ͨ�˲�

Fl1 = logpolar(Fb1);Fl2 = logpolar(Fb2);       % 5. ��ȡ�����������ʾ
[loga, theta, rm] = phase_corr(Fl1, Fl2)       % 6. ��λ��ط���������ת
[m ,n] = size(f1);fz2 = imrotate(f2, -theta, 'bilinear');
f3 = imscale(fz2, m, n, 1.044^(loga));	
[x0, y0, rm1] = phase_corr(f1, f3)
[x1, y1, rm2] = phase_corr(f1, imrotate(f3, 180, 'bilinear'))
if rm1<rm2
    f3 = imrotate(f3, 180, 'bilinear');                     % 7. ��ͼ2���нǶ��жϣ�������ת���ű任
    x0=x1;y0=y1;
end
subplot(2,2,3),imshow(f3,[]),title('��ת����'); % 8. ��λ��ط���λ��
se = translate(strel(1), [x0 y0]);f3n = imdilate(f3,se);
subplot(2,2,4),imshow(f3n,[]),title('��׼��');  % 9. ��ͼ�������׼
figure,imshow(Fb1);
drawnow