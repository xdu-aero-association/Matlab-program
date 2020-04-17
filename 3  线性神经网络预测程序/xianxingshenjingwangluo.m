
%% 学习目标： 线性神经网络
%%  收敛速度和精度比之前讲的感知器神经网络要高，
%%  主要应用在函数逼近，信号预测，模式识别，系统辨识方面
clear all;
close all;
P=[1.1 2.2 3.1 4.1];
T=[2.2 4.02 5.8 8.1];
lr=maxlinlr(P);                   %获取最大学习速率
net=newlin(minmax(P),1,0,lr);     %建立线性神经网络
net.trainParam.epochs=500;        %训练    做多500次
net.trainParam.goal=0.04;         %训练误差设定为0.04
net=train(net,P,T);
Y=sim(net,P)                       %仿真
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂
%%   大鱼号：在线教育大仙一品堂
%%   一点资讯号：大仙一品堂
%%    2018/3/20  录制，欢迎指正
%%  利用线性神经网络进行信号的预测
clear all;
close all;
t=0:pi/10:4*pi;
X=t.*sin(t);
T=2*X+3;
figure;
plot(t,X,'+-',t,T,'+--');
legend('系统输入','系统输出');
set(gca,'xlim',[0 4*pi]);
set(gcf,'position',[50,50,400,400]);
net=newlind(X,T);
y=sim(net,X);
figure;
plot(t,y,'+:',t,y-T,'r:');
legend('网络预测输出','误差');
set(gca,'xlim',[0 4*pi]);
set(gcf,'position',[50,50,400,400]);

%%  