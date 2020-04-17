%%初始部分，读取图像及计算相关信息
clear;
close all;
clc;
%format long;
t0=clock;
I=imread('Lenna.bmp');
threshold_opt=graythresh(I);
I1=im2bw(I,96/256);
figure(1);
imshow(I);
title('源图');
figure(2);
imshow(I1);
title('阈值分割后的图像');
threshold_opt*255

t1=clock;
search_time=etime(t1,t0);
search_time