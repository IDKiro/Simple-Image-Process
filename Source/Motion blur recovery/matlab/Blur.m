f = imread('test_sharp.jpg');
H = fspecial('motion', 16, 20);
I = im2double(f);
BI = imfilter(I, H);
BI = im2double(BI);
imwrite(BI,'test_blur.jpg')