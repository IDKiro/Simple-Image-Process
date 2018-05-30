function angle = ang(I)
    
    FI = fftshift(log10(1+abs(fft2(I))));

    for theta = 1:180
        r = radon(FI,theta);
        R(theta) = max(max(r));
    end

    angle = find(R == max(max(R)));

end