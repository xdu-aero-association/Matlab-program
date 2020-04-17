function [ net ] = gabptrain( gaP,bpP,P,T )
%gabptrain 结合遗传算法的神经网络训练
%  gaP 为遗传算法的参数信息.[遗传代数 最小适应值]。
%  bpP 为神经网络参数信息。[最大迭代次数　最小误差]
%  P 为样本数组
%  T 为目标数组
[W1, B1, W2, B2] = getWBbyga(gaP);
net = initnet(W1, B1, W2, B2,bpP);
net = train(net,P,T);