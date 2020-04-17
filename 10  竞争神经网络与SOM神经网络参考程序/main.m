%% I. 清空环境变量
clear all
clc

%% II. 训练集/测试集产生
%%
% 1. 导入数据
load water_data.mat

%%
% 2. 数据归一化
attributes = mapminmax(attributes);

%%
% 3. 训练集和测试集划分

% 训练集——35个样本
P_train = attributes(:,1:35);
T_train = classes(:,1:35);
% 测试集——4个样本
P_test = attributes(:,36:end);
T_test = classes(:,36:end);

%% III. 竞争神经网络创建、训练及仿真测试
%%
% 1. 创建网络
net = newc(minmax(P_train),4,0.01,0.01);  %因为结果分成四类，所以这里隐含神经元设置为4，0.01分别是是权值和阈值的学习率
%单独执行一下minmax(P_train)发现最大值是1，最小值是-1，与P_train最大值最小值符合。
% 输入      w=net.iw{1,1};      看一下   连接权值      平均值为0   四个神经元六个特征   4*6矩阵元素全部为0
%输入      b=net.b{1}    看一下  连接阈值      edit  initcon      rows=4
%134行看一下  x的值是不是我们算的值

%%
% 2. 设置训练参数
net.trainParam.epochs = 500;     %训练步数

%%
% 3. 训练网络
net = train(net,P_train);     

%%
% 4. 仿真测试

% 训练集
t_sim_compet_1 = sim(net,P_train);
T_sim_compet_1 = vec2ind(t_sim_compet_1);
% 测试集
t_sim_compet_2 = sim(net,P_test);
T_sim_compet_2 = vec2ind(t_sim_compet_2);     % vec2ind函数将稀疏矩阵转换成行向量或者列向量，T-train和classes没有用到，体现了无导师学习的过程
%运行一下  77 78 行看一下结果      哪几个神经元决定了每一个类
%% IV. SOFM神经网络创建、训练及仿真测试
%%
% 1. 创建网络
net = newsom(P_train,[4 4]);

%%
% 2. 设置训练参数
net.trainParam.epochs = 200;

%%
% 3. 训练网络
net = train(net,P_train);

%%
% 4. 仿真测试

% 训练集
t_sim_sofm_1 = sim(net,P_train);
T_sim_sofm_1 = vec2ind(t_sim_sofm_1);
% 测试集
t_sim_sofm_2 = sim(net,P_test);
T_sim_sofm_2 = vec2ind(t_sim_sofm_2);

%% V. 结果对比
%%
% 1. 竞争神经网络
result_compet_1 = [T_train' T_sim_compet_1']
result_compet_2 = [T_test' T_sim_compet_2']

%%    1960009019    l13299109228
% 2. SOFM神经网络
result_sofm_1 = [T_train' T_sim_sofm_1']
result_sofm_2 = [T_test' T_sim_sofm_2']
