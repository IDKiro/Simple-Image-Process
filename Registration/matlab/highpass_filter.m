% 图像高通滤波器
function mat_out = highpass_filter(mat)

    %定义滤波器
    [m, n] = size(mat);
    x_product = zeros(m, n);
    ox = floor(m/2)+1;
    oy = floor(n/2)+1;
    for i=1:m
        for j=1:n
            if abs(i-ox) <= m/4 && abs(j-oy) <= n/4
                x_product(i, j) = cos(2*pi*(i-ox)./m).*cos(2*pi*(j-oy)./n);
            end
        end
    end
    Hpass = (ones(m, n)-x_product).*(2*ones(m, n)-x_product);

    % 将矩阵进行滤波
    mat_out = mat.*Hpass;
    
end