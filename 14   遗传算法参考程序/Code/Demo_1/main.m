%% I. 清空环境变量
%optimtool    solver   中选择   GA
%添加 gaot工具箱
clear all
clc

%% II. 绘制函数曲线
x = 0:0.01:9;
y =  x + 10*sin(5*x)+7*cos(4*x);

figure
plot(x, y)
xlabel('自变量')
ylabel('因变量')
title('y = x + 10*sin(5*x) + 7*cos(4*x)')
grid

%% III. 初始化种群
initPop = initializega(50,[0 9],'fitness');    %种群大小；变量变化范围；适应度函数的名称
%看一下initpop     第二列代表   适应度函数值
%% IV. 遗传算法优化
[x endPop bpop trace] = ga([0 9],'fitness',[],initPop,[1e-6 1 1],'maxGenTerm',25,...
                           'normGeomSelect',0.08,'arithXover',2,'nonUnifMutation',[2 25 3]);
%变量范围上下界；适应度函数；适应度函数的参数；初始种群；精度和显示方式；终止函数的名称；
%终止函数的参数；选择函数的名称；选择函数的参数；交叉函数的名称；交叉函数的参数；变异函数的
%名称；变异函数的参数
%  X    最优个体     endpop   优化终止的最优种群    bpop 最优种群的进化轨迹   trace   进化迭代过程中
%最优的适应度函数值和适应度函数值矩阵

%% V. 输出最优解并绘制最优点
x
hold on
plot (endPop(:,1),endPop(:,2),'ro')

%% VI. 绘制迭代进化曲线
figure(2)
plot(trace(:,1),trace(:,3),'b:')
hold on
plot(trace(:,1),trace(:,2),'r-')
xlabel('Generation'); ylabel('Fittness');
legend('Mean Fitness', 'Best Fitness')

