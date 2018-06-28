# -*- coding: UTF-8 -*-

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib.patches as patches
import numpy as np
from scipy import ndimage, misc

# 彩色图像转灰度图
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

# 图像高通滤波器
def HPF(ImgInput):
    (raw, col) = np.shape(ImgInput)
    xPr = np.zeros((raw, col))
    oraw = np.floor(raw/2)
    ocol = np.floor(col/2)
    for i in range(raw):
        for j in range(col):
            if abs(i-oraw) <= raw/4 and abs(j-ocol) <= col/4:
                xPr[i, j] = np.cos(2*np.pi*(i-oraw)/raw)*np.cos(2*np.pi*(j-ocol)/col)
    Hpass = (np.ones((raw, col))-xPr)*(2*np.ones((raw, col))-xPr)
    ImgOutput = ImgInput*Hpass
    return ImgOutput

# 图像对数极坐标变换
def logpolar(ImgInput):
    (raw, col) = np.shape(ImgInput)
    oraw = np.round(raw/2)
    ocol = np.round(col/2)
    radius = int(np.round(np.log(max(oraw, ocol))/np.log(1.044)))
    angle = 360
    ImgOutput = np.zeros((radius, angle))
    for i in range(radius):
        for j in range(angle):
            h = oraw+np.power(1.044, i+1)*np.sin((j+1)*np.pi/180)
            w = ocol+np.power(1.044, i+1)*np.cos((j+1)*np.pi/180)
            if h >= 1 and w >= 1 and h <= raw and w <= col:
                ImgOutput[i, j] = (np.floor(h)+1-h)*(np.floor(w)+1-w)*ImgInput[int(np.floor(h))-1, int(np.floor(w))-1]+(h-np.floor(h))*(np.floor(w)+1-w)*ImgInput[int(np.floor(h)), int(np.floor(w))-1]+(np.floor(h)+1-h)*(w-np.floor(w))*ImgInput[int(np.floor(h))-1, int(np.floor(w))]+(h-np.floor(h))*(w-np.floor(w))*ImgInput[int(np.floor(h)), int(np.floor(w))]
    return ImgOutput

# 相位相关法
def phacor(ImgInput1, ImgInput2):
    F1 = np.fft.fft2(ImgInput1)
    F2 = np.fft.fft2(ImgInput2)
    R = (F1*np.conj(F2))/abs(F1*F2)
    IR = np.fft.fftshift(np.fft.ifft2(R))
    (raw, col) = np.shape(F1)
    (oraw, ocol) = divmod(np.argmax(IR), col)
    i = oraw-np.floor(raw/2)
    j = ocol-np.floor(col/2)
    return (i, j, IR[oraw, ocol])

# 保持尺寸不变的图像缩放
def imscale(ImgInput, mo, no, s):
    (mi, ni) = np.shape(ImgInput)
    ImgScale = misc.imresize(ImgInput, 1/s)
    (raw, col) = np.shape(ImgScale)
    RawBeforePad = int(np.floor((mo-raw)/2))
    RawAfterPad = int(mo-raw-RawBeforePad)
    ColBeforePad = int(np.floor((no-col)/2))
    ColAfterPad = int(no-col-ColBeforePad)
    ImgOutput = np.lib.pad(ImgScale, ((RawBeforePad, RawAfterPad), (ColBeforePad, ColAfterPad)), 'constant', constant_values=0)
    return ImgOutput

if __name__=="__main__":
    f1 = mpimg.imread('test2_origin.jpg')
    f2 = mpimg.imread('test2_trans.jpg')

    plt.subplot(131)
    plt.imshow(f1)
    plt.axis('off')
    plt.subplot(132)
    plt.imshow(f2)
    plt.axis('off')

    f1g = rgb2gray(f1)
    f2g = rgb2gray(f2)

    # 不同分辨率的填充处理
    [raw1, col1] = np.shape(f1g)
    [raw2, col2] = np.shape(f2g)
    raw = max(raw1, raw2)
    col = max(col1, col2)
    f1g = np.lib.pad(f1g, ((0, raw-raw1), (0, col-col1)), 'constant', constant_values=0)
    f2g = np.lib.pad(f2g, ((0, raw-raw2), (0, col-col2)), 'constant', constant_values=0)

    # 图像快速傅里叶变换
    F1 = np.fft.fftshift(np.fft.fft2(f1g))
    F2 = np.fft.fftshift(np.fft.fft2(f2g))

    # 频谱取幅度谱并高通滤波，并取对数极坐标表示
    Fr1 = logpolar(HPF(abs(F1)))
    Fr2 = logpolar(HPF(abs(F2)))

    # 相位相关法求伸缩旋转量
    (loga, theta, rm) = phacor(Fr1, Fr2)
    scale = np.power(1.044, loga)

    print "The scale ratio is", scale
    print "The rotate angle is", theta

    if scale < 1:
        theta = -theta
        scale = 1/scale
        f1g, f2g = f2g, f1g
        f1, f2 = f2, f1
        raw1, raw2, col1, col2 = raw2, raw1, col2, col1

    # 伸缩旋转变换后用相位相关法求平移量
    f2Rotate = ndimage.rotate(f2g, -theta)
    f2Trans = imscale(f2Rotate, raw, col, scale)
    (Movraw, Movcol, rm1) = phacor(f1g, f2Trans)
    (Movraw180, Movcol180, rm2) = phacor(f1g, ndimage.rotate(f2Trans, 180))

    # 校正180°旋转，求得真正的平移量
    if rm1 < rm2:
        f2Trans = ndimage.rotate(f2Trans, 180)                   
        Movraw = Movraw180
        Movcol = Movcol180

    print "The movement pixel is", '(', Movraw, ',', Movcol, ')'

    # 绘制框选矩形 
    alpha = np.arctan(float(raw2)/col2)
    BoxHalfLen = np.power((np.power(raw2/scale, 2)+np.power(col2/scale, 2)), 0.5)/2
    beta = alpha+theta/180*np.pi
    rawOrigin = round(raw2/2+Movraw-BoxHalfLen*np.sin(beta)-1)
    colOrigin = round(col2/2+Movcol-BoxHalfLen*np.cos(beta)-1)
    rect = patches.Rectangle((colOrigin, rawOrigin), col2/scale, raw2/scale, angle=theta, edgecolor='r', facecolor='none')

    # 绘制结果
    plt.subplot(133)
    plt.imshow(f1)
    plt.axis('off')
    currentAxis = plt.gca()
    currentAxis.add_patch(rect)
    plt.show()
