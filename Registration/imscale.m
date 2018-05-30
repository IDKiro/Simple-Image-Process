% Í¼ÏñÉìËõ±ä»»
function [ mat_m_new] = imscale(mat_m, mo, no, s)

    [mi, ni] = size(mat_m); 
    m = round(mi/s);
    n = round(ni/s);
    mat_scaled = imresize(mat_m, 1/s, 'bicubic'); 
    mat_m_new = zeros(mo, no);
    if mo >= m && no >= n
        mat_m_new((floor(mo/2)-floor(m/2)+1):(floor(mo/2)-floor(m/2)+m), ((floor(no/2)-floor(n/2)+1):(floor(no/2)-floor(n/2)+n))) = mat_scaled((1:m), (1:n)); 
    else
        mat_m_new((1:mo), (1:no)) = mat_scaled((floor(m/2)-floor(mo/2)+1):(floor(m/2)-floor(mo/2)+mo), (floor(n/2)-floor(no/2)+1):(floor(n/2)-floor(no/2)+no));     
    end
    
end