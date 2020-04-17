%%  学习目标：使用遗传神经网络进行图像分割
clear all
clc
%用于产生样本文件
generatesample('sample.mat');  
%遗传神经网络训练示例
gaP = [100 0.00001];
bpP = [500 0.00001];
load('sample.mat');
gabptrain( gaP,bpP,p,t )
%神经网络分割示例
load('net.mat');%已经训练好的神经网络
img = imread('a.bmp');%等分割的图像
bw = segment( net,img ) ;%分割后的二值图像
figure;
subplot(1,2,1);
imshow(img);
title('分割前二值图像对比图')
subplot(1,2,2);
imshow(bw);
title('分割后二值图像对比图')
%传统BP训练
epochs = 200;
goal = 0.0001 ;
net = newcf([0 255],[7 1],{'tansig' 'purelin'});
net.trainParam.epochs = epochs;
net.trainParam.goal = goal ;
load('sample.mat');
net = train(net,p,t);
%遗传BP训练
%遗传算法寻找最优权值阈值会用一些时间，
gaP = [100 0.00001];
bpP = [500 0.00001];
gabptrain( gaP,bpP,p,t );
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 