%%  学习目标：模糊神经网络在函数逼近中的应用
clear all
clc
[x1,x2]=meshgrid(0:0.1:1,0:0.05:0.5);
y=0.5*(pi*(x1.^2)).*sin(pi*x2);            %求得函数输出值
x11=reshape(x1,121,1);                      %将输入变量变为列向量
x12=reshape(x2,121,1);
y1=reshape(y,121,1);                        %将输出变量变为列向量
trnData=[x11(1:2:121) x12(1:2:121) y1(1:2:121)]; %构造训练数据
chkData=[x11 x12 y1];                       %构造测试数据
numMFs=4;                                   %定义隶属函数个数
mfType='gbellmf';                           %定义隶属函数类型
epoch_n=30;                                 %定义训练次数
in_fisMat=genfis1(trnData,numMFs,mfType);   %采用genfis1函数由训练数据直接生成模糊推理系统
out_fisMat=anfis(trnData,in_fisMat,30);     %训练模糊系统
y11=evalfis(chkData(:,1:2),out_fisMat);     %用测试数据测试系统
x111=reshape(x11,11,11);
x112=reshape(x12,11,11);
y111=reshape(y11,11,11);
figure(1)
subplot(2,2,1),
mesh(x1,x2,y);
title('期望输出');
subplot(2,2,2),
mesh(x111,x112,y111);
title('实际输出');
subplot(2,2,3),
mesh(x1,x2,(y-y111));
title('误差');
[x,mf]=plotmf(in_fisMat,'input',1);
[x,mf1]=plotmf(out_fisMat,'input',1);
subplot(2,2,4),
plot(x,mf,'r-',x,mf1,'k--');
title('隶属度函数变化');
figure(2)
gensurf(out_fisMat)
title('推理输入输出关系图');
xlabel('输入x1');  
ylabel('输入x2'); 
zlabel('输出y'); 
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂