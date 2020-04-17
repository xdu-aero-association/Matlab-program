%% 学习目标： 建立具有稳定点的hopfield神经网络
clear all
clc
%%   定义具有3列的目标向量
T = [-1 1; 1 -1;-1 -1];

%%  绘制两个稳定点的Hopfield神经网络稳定空间图形
axis([-1 1 -1 1 -1 1])
set(gca,'box','on'); axis manual;  hold on;
plot3(T(1,:),T(2,:),T(3,:),'r*')
title('Hopfield Network State Space')
xlabel('a(1)');
ylabel('a(2)');
zlabel('a(3)');
view([37.5 30]);

%%  利用newhop创建Hopfield神经网络
net = newhop(T);
 
%%  定义随机起始点
a = {rands(3,1)};
%%  Hopfield仿真参数设定
[y,Pf,Af] = net({1 10},{},a);

%%  在稳定空间内设定一个活动的点
record = [cell2mat(a) cell2mat(y)];
start = cell2mat(a);
hold on
plot3(start(1,1),start(2,1),start(3,1),'bx', ...
   record(1,:),record(2,:),record(3,:))

%%   重复模拟20个初始条件
color = 'rgbmy';
for i=1:20
   a = {rands(3,1)};
   [y,Pf,Af] = net({1 10},{},a);
   record=[cell2mat(a) cell2mat(y)];
   start=cell2mat(a);
   plot3(start(1,1),start(2,1),start(3,1),'kx', ...
      record(1,:),record(2,:),record(3,:),color(rem(i,5)+1))
end

%%  使用向量P的每一列仿真Hopfield神经网络
P = [ 1  -1  -0.5  1  1 ; ...
      0   0   0  0  0; ...
     -1   1   0.5  -1  -1];
cla
plot3(T(1,:),T(2,:),T(3,:),'r*')
color = 'rgbmy';
for i=1:5
   a = {P(:,i)};
   [y,Pf,Af] = net({1 10},{},a);
   record=[cell2mat(a) cell2mat(y)];
   start=cell2mat(a);
   plot3(start(1,1),start(2,1),start(3,1),'kx', ...
      record(1,:),record(2,:),record(3,:),color(rem(i,5)+1))
end

%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 