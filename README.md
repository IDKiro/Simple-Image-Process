# Simple Image Process

## Registration

### 功能：

将两张有相同部分的图像进行旋转、缩放和平移后进行配准。

### 原理：

基于图片平移后图片旋转、伸缩频谱特性不变的特点先求得旋转伸缩量，对图片作旋转、伸缩复原处理后求平移量。基于相位相关法，非基于特征点。

### TODO：

1. 不同分辨率、不同形状的图像配准可能存在一定的问题

## Motion blur recovery

### 功能：

直线模糊核的运动模糊图像去模糊。

### 原理：

基于运动模糊图像的频谱特性，使用radon变换及radon-d变换来计算运动模糊模糊核的角度和长度。

### TODO：
1. MATLAB程序的求模糊角度函数存在问题，需要重新编写（上传的最终版丢失，这是较早版本）
2. python程序的编写
3. 彩色图片、一般分辨率图片的处理

## Defocus blur recovery

### 功能：

高斯模糊核的失焦模糊图像去模糊。

### 原理：

基于失焦模糊图像的频谱特性，使用radon-c变换得到圆上的灰度平均值并绘制成半径和平均灰度的关系函数，使用函数拟合求得参数得到高斯模糊核的半径。

### TODO：

1. python程序的编写
2. 彩色图片、一般分辨率图片的处理
