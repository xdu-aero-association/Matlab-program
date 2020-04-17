function  inpt  = pretreatment(I)
global A
%%  图像归一化处理以及特征提取


         %%   下面的if和else是为了如果图像是三色图（RGB），转换成灰度图
        if length(size(I))==3
            I1 = rgb2gray(I);
        else
           I1 =I;
        end


%%  将图片统一划为50*20大小
I1=imresize(I1,[50 20]);
I1=im2bw(I1,0.9);
[m,n]=size(I1);
A=I1;
inpt=zeros(1,m*n);
%%   将图像按列转换成一个行向量
for j=1:n
    for i=1:m
        inpt(1,m*(j-1)+i)=I1(i,j);
    end
end
