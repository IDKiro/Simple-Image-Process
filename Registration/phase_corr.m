%��λ��ط�
function [i, j, IRmax]=phase_corr(f1, f2)
F1 = fft2(f1);
F2 = fft2(f2);
R=(F1.*conj(F2))./abs(F1.*F2); %%�������׵ļ���
IR=fftshift(ifft2(R));  %%����Ҷ���任���������� 
%�����ֵ������λ�ã�����ƽ��λ�á� 
[m n]=size(F1);
IRmax = max(max(IR));
[ox oy]=find(IR==IRmax);
i = ox-floor(m/2)-1;
j = oy-floor(n/2)-1;
%��׼��������� i �� j ��. 
end