% 相位相关法
function [i, j, IRmax]=phase_corr(f1, f2)

    % 互能量谱的计算,傅立叶反变换求出冲击函数 
    F1 = fft2(f1);
    F2 = fft2(f2);
    R = (F1.*conj(F2))./abs(F1.*F2);    
    IR = fftshift(ifft2(R));            

    % 找最大值发生的位置，就是平移位置
    [m n] = size(F1);
    IRmax = max(max(IR));
    [ox oy] = find(IR == IRmax);

    % 对准的坐标存在 i 和 j 中
    i = ox-floor(m/2)-1;
    j = oy-floor(n/2)-1;
    
end