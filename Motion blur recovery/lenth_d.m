function d = lenth_d(I, theta)

    [m, n] = size(I);

    FI = abs(fftshift(fft2(I)));
    FIlog = log(1+FI);                  %求幅度谱平移并取对数
    Fc = radon_d(FIlog, theta)          %进行radon-d变换

    [k, l] = size(Fc);
    p = [1:l];
    a = [0, 0, 0, 0, 1, 1];

    for x = 20:20:20*max(m, n)
    f = @(a, p) a(1).*p.^3+a(2).*p.^2+a(3).*p+a(4)+a(5).*log(1+a(6).*abs(sinc(x*p)));
    [xm, v1] = lsqcurvefit(f, a, p, Fc);
    v(x/20) = v1;
    end

    xmin = find(v == min(min(v)));
    d = max(max(xmin))/n*20;

end
