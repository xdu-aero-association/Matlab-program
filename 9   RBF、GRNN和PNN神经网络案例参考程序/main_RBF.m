%% I. 清空环境变量
clear all
clc

%% II. 训练集/测试集产生
%%
% 1. 导入数据
load spectra_data.mat

%%
% 2. 随机产生训练集和测试集
temp = randperm(size(NIR,1));
% 训练集——50个样本
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';
% 测试集——10个样本
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';
N = size(P_test,2);

%% III. RBF神经网络创建及仿真测试
%%
% 1. 创建网络     
net = newrbe(P_train,T_train,0.09);     %这里spread设置为30
%创建之后可以通过    w1=net.iw{1,1};   隐含层和输入层的连接权值   
%看看W1的转置是不是跟P_train 元素相等    isequal(w1',P_train)   
%%     b1=net.b{1};        edit newrbe    127 hang       30   看看相等不  sqrt(-log(.5))/30
%可以调整spread   设置newrbe中的断点x = t/[a1; ones(1,q)];   运行  创建网络的函数语句
% 2. 仿真测试
T_sim = sim(net,P_test);

%% IV. 性能评价
%%
% 1. 相对误差error
error = abs(T_sim - T_test)./T_test;

%%
% 2. 决定系数R^2
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%%
% 3. 结果对比
result = [T_test' T_sim' error']

%% V. 绘图
figure
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o')
legend('真实值','预测值')
xlabel('预测样本')
ylabel('辛烷值')
string = {'测试集辛烷值含量预测结果对比';['R^2=' num2str(R2)]};
title(string)

