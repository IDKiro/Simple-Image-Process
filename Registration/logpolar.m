%ͼ������������ʾ
function output=logpolar(input) 
[m n]=size(input);
oy=round(m/2);
ox=round(n/2);
radius=round(log(max(ox,oy))/log(1.044));
angle=360;      %�任��ͼ��Ŀ�
output=zeros(radius,angle);
for i=1:radius          %���������������ͬ�����һ��
    for j=1:angle       %����������ǣ���Ϊ360
    %oy,ox��Ϊ������任�������꣬��Ҫ��Ϊƫ�������
        h=oy+1.044^i*sin(j*pi/180);
        w=ox+1.044^i*cos(j*pi/180);
        if h>=1 && w>=1 && h<=m && w<=n  %����ԭͼ������غ���
            output(i,j)=(floor(h)+1-h)*(floor(w)+1-w)*input(floor(h),floor(w))+(h-floor(h))*(floor(w)+1-w)*input(floor(h)+1,floor(w))+(floor(h)+1-h)*(w-floor(w))*input(floor(h),floor(w)+1)+(h-floor(h))*(w-floor(w))*input(floor(h)+1,floor(w)+1); %˫���Բ�ֵ    
        end
    end
end
