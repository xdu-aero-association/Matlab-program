%%  学习目标：BP神经网络
%%  函数逼近  数据压缩   模式识别
%%  考虑要素：网络层数  输入层的节点数  输出层的节点数  隐含层的节点数
%%  传输函数  训练方法
%%  对信号曲线进行拟合
clear all;
clear all;
P=-1:0.04:1;
T=sin(2*pi*P)+0.1*randn(size(P));
net=newff(P,T,18,{},'trainbr');    %%   隐含层神经元个数是18
net.trainParam.show=10;
net.trainParam.epochs=100;         %%  训练100次
net=train(net,P,T);
Y=sim(net,P);
figure;
plot(P,T,'-',P,Y,'+');
legend('原始信号','网络输出信号');
set(gcf,'position',[20,20,500,400]);
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂
%%   大鱼号：在线教育大仙一品堂
%%   一点资讯号：大仙一品堂
%%    2018/3/21 录制，欢迎指正