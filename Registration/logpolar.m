%图像对数极坐标表示
function output=logpolar(input) 
[m n]=size(input);
oy=round(m/2);
ox=round(n/2);
radius=round(log(max(ox,oy))/log(1.044));
angle=360;      %变换后图像的宽
output=zeros(radius,angle);
for i=1:radius          %纵坐标代表极径，不同情况不一样
    for j=1:angle       %横坐标代表极角，恒为360
    %oy,ox作为极坐标变换中心坐标，需要作为偏移量相加
        h=oy+1.044^i*sin(j*pi/180);
        w=ox+1.044^i*cos(j*pi/180);
        if h>=1 && w>=1 && h<=m && w<=n  %超出原图像的像素忽略
            output(i,j)=(floor(h)+1-h)*(floor(w)+1-w)*input(floor(h),floor(w))+(h-floor(h))*(floor(w)+1-w)*input(floor(h)+1,floor(w))+(floor(h)+1-h)*(w-floor(w))*input(floor(h),floor(w)+1)+(h-floor(h))*(w-floor(w))*input(floor(h)+1,floor(w)+1); %双线性插值    
        end
    end
end
