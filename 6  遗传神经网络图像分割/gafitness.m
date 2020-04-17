function f = gafitness(y)
% 遗传算法的适应值计算
% y - 染色体个体
% f - 染色体适应度
[P,T,R,S1,S2,Q,S]=nninit;
x=y;

[W1, B1, W2, B2, P, T, A1, A2, SE, val]=gadecod(x);
f = val ;