clear;clf;clc;
f1 = imread('lll4.bmp');f2 = imread('lll8.bmp');% 1. 读取图片 
subplot(2,2,1),imshow(f1,[]),title('配准图');
subplot(2,2,2),imshow(f2,[]),title('待配准图');    % 2. 显示配准图像
F1 = fftshift(fft2(f1));   F2 = fftshift(fft2(f2));% 3. 对图像进行快速傅里叶变换  
Fa1 = abs(F1); Fa2 = abs(F2);
Fb1 = highpass_filter(Fa1);Fb2 = highpass_filter(Fa2);% 4. 取幅度谱并高通滤波

Fl1 = logpolar(Fb1);Fl2 = logpolar(Fb2);       % 5. 并取对数极坐标表示
[loga, theta, rm] = phase_corr(Fl1, Fl2)       % 6. 相位相关法求伸缩旋转
[m ,n] = size(f1);fz2 = imrotate(f2, -theta, 'bilinear');
f3 = imscale(fz2, m, n, 1.044^(loga));	
[x0, y0, rm1] = phase_corr(f1, f3)
[x1, y1, rm2] = phase_corr(f1, imrotate(f3, 180, 'bilinear'))
if rm1<rm2
    f3 = imrotate(f3, 180, 'bilinear');                     % 7. 将图2进行角度判断，进行旋转缩放变换
    x0=x1;y0=y1;
end
subplot(2,2,3),imshow(f3,[]),title('旋转缩放'); % 8. 相位相关法求位移
se = translate(strel(1), [x0 y0]);f3n = imdilate(f3,se);
subplot(2,2,4),imshow(f3n,[]),title('配准后');  % 9. 对图像进行配准
figure,imshow(Fb1);
drawnow