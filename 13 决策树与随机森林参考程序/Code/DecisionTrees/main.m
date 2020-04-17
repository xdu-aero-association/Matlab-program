%% I. 清空环境变量
clear all
clc
warning off

%% II. 导入数据     第一列是序号     第二列是良性还是恶性（乳腺癌）  后面是特征属性30个
load data.mat

%%
% 1. 随机产生训练集/测试集
a = randperm(569);
Train = data(a(1:500),:);        %产生500个训练集
Test = data(a(501:end),:);       %剩下的是测试集  69个

%%
% 2. 训练数据
P_train = Train(:,3:end);
T_train = Train(:,2);

%%
% 3. 测试数据
P_test = Test(:,3:end);
T_test = Test(:,2);

%% III. 创建决策树分类器
ctree = ClassificationTree.fit(P_train,T_train);

%%
% 1. 查看决策树视图
view(ctree);
view(ctree,'mode','graph');

%% IV. 仿真测试
T_sim = predict(ctree,P_test);

%% V. 结果分析
count_B = length(find(T_train == 1));
count_M = length(find(T_train == 2));
rate_B = count_B / 500;
rate_M = count_M / 500;
total_B = length(find(data(:,2) == 1));
total_M = length(find(data(:,2) == 2));
number_B = length(find(T_test == 1));
number_M = length(find(T_test == 2));
number_B_sim = length(find(T_sim == 1 & T_test == 1));
number_M_sim = length(find(T_sim == 2 & T_test == 2));
disp(['病例总数：' num2str(569)...
      '  良性：' num2str(total_B)...
      '  恶性：' num2str(total_M)]);
disp(['训练集病例总数：' num2str(500)...
      '  良性：' num2str(count_B)...
      '  恶性：' num2str(count_M)]);
disp(['测试集病例总数：' num2str(69)...
      '  良性：' num2str(number_B)...
      '  恶性：' num2str(number_M)]);
disp(['良性乳腺肿瘤确诊：' num2str(number_B_sim)...
      '  误诊：' num2str(number_B - number_B_sim)...
      '  确诊率p1=' num2str(number_B_sim/number_B*100) '%']);
disp(['恶性乳腺肿瘤确诊：' num2str(number_M_sim)...
      '  误诊：' num2str(number_M - number_M_sim)...
      '  确诊率p2=' num2str(number_M_sim/number_M*100) '%']);
  
%% VI. 叶子节点含有的最小样本数对决策树性能的影响
leafs = logspace(1,2,10);

N = numel(leafs);

err = zeros(N,1);
for n = 1:N
    t = ClassificationTree.fit(P_train,T_train,'crossval','on','minleaf',leafs(n));
    err(n) = kfoldLoss(t);
end
plot(leafs,err);
xlabel('叶子节点含有的最小样本数');
ylabel('交叉验证误差');
title('叶子节点含有的最小样本数对决策树性能的影响')

%% VII. 设置minleaf为13，产生优化决策树
OptimalTree = ClassificationTree.fit(P_train,T_train,'minleaf',13);
view(OptimalTree,'mode','graph')

%%
% 1. 计算优化后决策树的重采样误差和交叉验证误差
resubOpt = resubLoss(OptimalTree)
lossOpt = kfoldLoss(crossval(OptimalTree))

%%
% 2. 计算优化前决策树的重采样误差和交叉验证误差
resubDefault = resubLoss(ctree)
lossDefault = kfoldLoss(crossval(ctree))

%% VIII. 剪枝
[~,~,~,bestlevel] = cvLoss(ctree,'subtrees','all','treesize','min')
cptree = prune(ctree,'Level',bestlevel);
view(cptree,'mode','graph')

%%
% 1. 计算剪枝后决策树的重采样误差和交叉验证误差
resubPrune = resubLoss(cptree)
lossPrune = kfoldLoss(crossval(cptree))

