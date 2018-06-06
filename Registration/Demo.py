# -*- coding: UTF-8 -*-

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib.patches as patches
from scipy import ndimage, misc
import numpy as np

# 彩色图像转灰度图
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

# 图像高通滤波器
def HPF(img_input):
    (raw, col) = np.shape(img_input)
    x_product = np.zeros((raw, col))
    ox = np.floor(raw/2)
    oy = np.floor(col/2)
    for i in range(raw):
        for j in range(col):
            if abs(i-ox) <= raw/4 and abs(j-oy) <= col/4:
                x_product[i, j] = np.cos(2*np.pi*(i-ox)/raw)*np.cos(2*np.pi*(j-oy)/col)
    Hpass = (np.ones((raw, col))-x_product)*(2*np.ones((raw, col))-x_product)
    img_output = img_input*Hpass
    return img_output

# 图像对数极坐标变换
def logpolar(img_input):
    (raw, col) = np.shape(img_input)
    ox = np.round(raw/2)
    oy = np.round(col/2)
    radius = int(np.round(np.log(max(ox, oy))/np.log(1.044)))
    angle = 360
    img_output = np.zeros((radius, angle))
    for i in range(radius):
        for j in range(angle):
            h = oy+np.power(1.044, i+1)*np.sin((j+1)*np.pi/180)
            w = ox+np.power(1.044, i+1)*np.cos((j+1)*np.pi/180)
            if h >= 1 and w >= 1 and h <= raw and w <= col:
                img_output[i, j] = (np.floor(h)+1-h)*(np.floor(w)+1-w)*img_input[int(np.floor(h))-1, int(np.floor(w))-1]+(h-np.floor(h))*(np.floor(w)+1-w)*img_input[int(np.floor(h)), int(np.floor(w))-1]+(np.floor(h)+1-h)*(w-np.floor(w))*img_input[int(np.floor(h))-1, int(np.floor(w))]+(h-np.floor(h))*(w-np.floor(w))*img_input[int(np.floor(h)), int(np.floor(w))]
    return img_output

def phacor(img_input_1, img_input_2):
    F1 = np.fft.fft2(img_input_1)
    F2 = np.fft.fft2(img_input_2)
    R = (F1*np.conj(F2))/abs(F1*F2)
    IR = np.fft.fftshift(np.fft.ifft2(R))
    (raw, col) = np.shape(F1)
    (ox, oy) = divmod(np.argmax(IR), col)
    i = ox-np.floor(raw/2)-1
    j = oy-np.floor(col/2)-1
    return (i, j, IR[ox, oy])

def imscale(img_input, mo, no, s):
    (mi, ni) = np.shape(img_input)
    raw = round(mi/s)
    col = round(ni/s)
    img_scale = misc.imresize(img_input, 1/s)
    if mo > raw and no > col:
        bp = int(np.round((mo-raw)/2))
        ap = int(mo-raw-np.round((mo-raw)/2)+1)
        img_output = np.lib.pad(img_scale, ((bp, ap), (bp, ap)), 'constant', constant_values=0)
    else:
        img_output = img_scale[floor(raw/2)-floor(mo/2):floor(raw/2)-floor(mo/2)+mo, floor(col/2)-floor(no/2):floor(col/2)-floor(no/2)+no]
    return img_output

f1 = mpimg.imread('test1.jpg')
f2 = mpimg.imread('test2.jpg')
f1g = rgb2gray(f1)
f2g = rgb2gray(f2)

[raw, col] = np.shape(f1g)

# 图像快速傅里叶变换
F1 = np.fft.fftshift(np.fft.fft2(f1g))
F2 = np.fft.fftshift(np.fft.fft2(f2g))

# 频谱取幅度谱并高通滤波，并取对数极坐标表示
Fr1 = logpolar(HPF(abs(F1)))
Fr2 = logpolar(HPF(abs(F2)))

# 相位相关法求伸缩旋转量
(loga, theta, rm) = phacor(Fr1, Fr2)
scale = np.power(1.044, loga)

# 伸缩旋转变换后用相位相关法求平移量
f2_rotate = ndimage.rotate(f2g, -theta)
f2_trans = imscale(f2_rotate, raw, col, scale)
(mov_x, mov_y, rm1) = phacor(f1g, f2_trans)
(mov_x_180, mov_y_180, rm2) = phacor(f1g, ndimage.rotate(f2_trans, 180))

# 校正180°旋转，求得真正的平移量
if rm1 < rm2:
    f2_trans = ndimage.rotate(f2_trans, 180)                   
    mov_x = mov_x_180
    mov_y = mov_y_180

# 绘制框选矩形 
gama = np.arctan(raw/col)
box_half_len = np.power((np.power(raw/scale, 2)+np.power(col/scale, 2)), 0.5)/2
x_origin = round(raw/2+mov_x-box_half_len*np.cos(gama+theta/180*np.pi))
y_origin = round(col/2+mov_y-box_half_len*np.sin(gama+theta/180*np.pi))
rect = patches.Rectangle((x_origin, y_origin), raw/scale, col/scale, angle=theta, edgecolor='r', facecolor='none')

# 绘制结果
plt.subplot(131)
plt.imshow(f1)
plt.axis('off')
plt.subplot(132)
plt.imshow(f2)
plt.axis('off')
plt.subplot(133)
plt.imshow(f1)
plt.axis('off')
currentAxis = plt.gca()
currentAxis.add_patch(rect)
plt.show()

