function out = radon_d(input, theta)

    [m, n] = size(input);
    oy = round(m/2);
    ox = round(n/2);
    radius = floor(min(m, n)/(2^0.5));    
    output = zeros(radius);
    for i = 1:radius         
        k = 0;
        j = theta;
        for s = -radius:radius
            h = oy+i*cos(j*pi/180)-s*sin(j*pi/180);
            w = ox+i*sin(j*pi/180)+s*cos(j*pi/180);
            if h >= 1 && w >= 1 && h < m && w < n 
            k = k+(floor(h)+1-h)*(floor(w)+1-w)*input(floor(h), floor(w))+(h-floor(h))*(floor(w)+1-w)*input(floor(h)+1, floor(w))+(floor(h)+1-h)*(w-floor(w))*input(floor(h), floor(w)+1)+(h-floor(h))*(w-floor(w))*input(floor(h)+1, floor(w)+1);  
            end
        end
        out(i) = k;
    end

end