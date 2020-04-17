
%% 学习目标： 用RBF网络来实现非线性的函数回归
clc 
clear all

%% 产生输入变量x1 x2
x1=-1:0.01:1;
x2=-1:0.01:1;

%%  产生输出变量y
y=60+x1.^2-6*cos(6*pi*x1)+6*x2.^2-6*cos(6*pi*x2); 
 
%%  建立RBF网络
net=newrbe([x1;x2],y)
 
%%  网络仿真
t=sim(net,[x1;x2]);
 
%%  绘制拟合效果图
figure(1)
plot3(x1,x2,y,'rd');
hold on;
plot3(x1,x2,t,'b-.');
view(100,25)
title(' RBF神经网络的拟合效果')
xlabel('x1')
ylabel('x2')
zlabel('y')
grid on 


%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 
