function r = fitfunc(p, x)

% �����򻯵���Ϸ��̣���ֹ�����

r = zeros(length(x),1);
s1 = p(2)*p(1)^(p(3)-p(4));

for i = 1:length(x)
    if x(i) < p(1)
        r(i) = p(2).*x(i).^p(3);
    else
        r(i) =  s1 .*x(i).^p(4);
    end
end

% �������ԭ�ĵ���Ϸ��̣�̫���ӣ��ᵼ�¹����
% r = zeros(length(x),1);
% 
% d = p(2)*p(3)/p(4)*p(1)^(p(3)-p(4));
% e = p(2)*p(1)^p(3)-d*p(1)^p(4);
% 
% x=abs(x);
% 
% for i = 1:length(x)
%     if x(i) == 0
%         continue;
%     end
%     if x(i) < p(1)
%         r(i) = p(2).*x(i).^p(3);
%     else
%         r(i) =  d .*x(i).^p(4) + e;
%     end
% end









