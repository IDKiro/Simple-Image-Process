clear; clc; clf; 

% 读取图片 
f1 = imread('test1.jpg');
f2 = imread('test2.jpg');

% 显示配准图像
subplot(2, 2, 1), imshow(f1, []), title('配准图');
subplot(2, 2, 2), imshow(f2, []), title('待配准图');    

% 对图像进行快速傅里叶变换，取幅度谱并高通滤波，并取对数极坐标表示
F1 = fftshift(fft2(f1));   
F2 = fftshift(fft2(f2));  
Fa1 = abs(F1); 
Fa2 = abs(F2);
Fb1 = highpass_filter(Fa1);
Fb2 = highpass_filter(Fa2);
Fl1 = logpolar(Fb1);
Fl2 = logpolar(Fb2);  

% 相位相关法求伸缩旋转
[loga, theta, rm] = phase_corr(Fl1, Fl2);       
[m ,n] = size(f1);
fz2 = imrotate(f2, -theta, 'bilinear');
f3 = imscale(fz2, m, n, 1.044^(loga));	
[x0, y0, rm1] = phase_corr(f1, f3);
[x1, y1, rm2] = phase_corr(f1, imrotate(f3, 180, 'bilinear'));

% 将图2进行角度判断，进行旋转缩放变换
if rm1<rm2
    f3 = imrotate(f3, 180, 'bilinear');                     
    x0=x1;
    y0=y1;
end

% 相位相关法求位移
subplot(2, 2, 3), imshow(f3, []), title('旋转缩放'); 
se = translate(strel(1), [x0 y0]);
f3n = imdilate(f3,se);

% 对图像进行配准显示
subplot(2, 2, 4), imshow(f3n, []), title('配准后');  