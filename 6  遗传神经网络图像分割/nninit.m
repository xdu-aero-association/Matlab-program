function [P,T,R,S1,S2,Q,S]=nninit
% BP网络初始化:给出网络的训练样本P、T,
% 输入、输出数及隐含神经元数R,S2,S1
P = [0:3:255] ;
T = zeros(1,86);
T(29:86) = 1 ;
[R,Q]=size(P);
[S2,Q]=size(T);
S1=6;               %隐含层神经元数量
S=R*S1+S2+S1+S2; % 遗传算法编码长度