%%   学习目标：  学习BP神经网络字母识别
%%    QQ：1960009019
%%   更多matlab精彩专题课程和案例，可以搜索微信公众号：大仙一品堂

clear all             %清空环境变量
p(1:256,1)=1;         %P为256行1列，全部赋值为1
p1=ones(16,16);       %初始化16*16的二值图像，像素值全部为1（全白)，0是全黑
load E11net net;      %加载训练后的BP网络
test=input('输入图像:','s');       %提示输入图像文件名，需要添加后缀
if isempty(test),test=0;
end
if test==0,
    disp('输入错误，请重新输入图像名称和完整后缀');
    test=input('请输入图像:','s');         %提示输入图像文件名
end
figure(2)
x=imread(test,'bmp');         %读入图像
subplot 121,imshow(x);
title('输入图像');
hold on;
bw=im2bw(x,0.5);              %将读入的训练样本图像x转换为二值图像bw
[i,j]=find(bw==0);            %寻找二值图像bw中像素值为0（黑色）的行号i和列号j
imin=min(i);                  %寻找二值图像bw中像素值为0(黑色)的最小行号imin
imax=max(i);                  %寻找二值图像bw中像素值为0(黑色)的最大行号imax
jmin=min(j);                  %寻找二值图像bw中像素值为0的最小列号jmin
jmax=max(j);                  %寻找二值图像bw中像素值为0的最大列号jmax
bw1=bw(imin:imax,jmin:jmax);    %截取图像像素值为0的最大矩形区域bw1
rate=16/max(size(bw1));         %计算转换为16*16的二值图像的缩放比例rate
bw1=imresize(bw1,rate);         %将截取图像转换为16 x 16的二值图像bw1
[i,j]=size(bw1);                %转换图像bw1的大小
i1=round((16-i)/2);             %计算转换图像bw1的宽度与16的差距
j1=round((16-j)/2);             %计算转换图像bw1的高度与16的差距
p1(i1+1:i1+i,j1+1:j1+j)=bw1;    %将截取图像转换为标准的16*16的图像
p1=-1.*p1+ones(16,16);          %反色处理
 for m =0:15
        p(m*16+1:(m+1)*16,1)=p1(1:16,m+1);      %形成测试样本输入向量
 end
    
 [a,Pf,Af]=sim(net,p);                           %BP神经网络网络仿真
    subplot 122,imshow(p1);title('测试图像结果显示');        %显示测试图像
    
   

