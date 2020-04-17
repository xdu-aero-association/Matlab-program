function [ bw ] = segment( net,img )
%segment 利用训练好的神经网络进行分割图像
%  net - 已经训练好的神经网络
%  img - 等分割的图像
%输出 bw - 分割后的二值图像
[m n] = size(img);
P = img(:) ;
P = double(P);
P = P' ;
T = sim(net,P);
T(T<0.5) = 0 ;
T(T>0.5) = 255 ;
t = uint8(T);
t = t';
 bw = reshape(t,m,n);