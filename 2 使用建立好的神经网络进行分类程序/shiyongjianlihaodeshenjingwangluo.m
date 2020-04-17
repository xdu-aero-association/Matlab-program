%% 学习目标：使用建立好的神经网络（训练好并保存，下次直接调用该神经网络）进行分类

clear all;
close all;
P=[-0.4 -0.4 0.5 -0.2 -0.7;-0.6 0.6 -0.4 0.3 0.8];      %输入向量
T=[1 1 0 0 1];                                          %输出向量
plotpv(P,T);                                            %绘制样本
net=newp(minmax(P),1,'hardlim','learnpn');              %建立神经网络
hold on;
linehandle=plot(net.IW{1},net.b{1});
E=1;
net.adaptParam.passes=10;
while mae(E)                                            %误差达到要求才停止训练
    [net,Y,E]=adapt(net,P,T);                           %进行感知器神经网络的训练
    linehandle=plotpc(net.IW{1},net.b{1},linehandle);
    drawnow;
end
save net1 net;                                          %将训练好的神经网络进行保存
set(gcf,'position',[60,60,300,300]);

%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂
%%   大鱼号：在线教育大仙一品堂
%%   一点资讯号：大仙一品堂
%%    2018/3/20  录制，欢迎指正
%%  用刚才建立的神经网络进行分类
clear all;
close all;
load net1.mat;                                  %加载上次训练好的神经网络
X=[-0.3 0.3 0.9;-0.6 0.2 0.8];                  %输入向量
Y=sim(net,X);                                   %对输入进行仿真
figure;
plotpv(X,Y);                                    %绘制样本点
plotpc(net.IW{1},net.b{1});                     %绘制分类线
set(gcf,'position',[60,60,300,300]);

%%  