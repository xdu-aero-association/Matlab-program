function [W1, B1, W2, B2, P, T, A1, A2, SE, val]=gadecod(x)
% 将遗传算法的编码分解为BP网络所对应的权值、阈值
%   x　为一个染色体
%  W1 为输入层到隐层权值
%  B1 为输入层到隐层阈值
%  W2 为隐层到输出层权值
%  B2 为隐层到输出层阈值
%  P  为训练样本
%  T　为样本输出值
%  A1 为输入层到隐层误差
%  A2 为隐层到输出层误差
%  SE 为误差平方和
%  val 为遗传算法的适应值
[P,T,R,S1,S2,Q,S]=nninit;
% 前S1个编码为W1
 for i=1:S1,
    W1(i,1)=x(i);
end
% 接着的S1*S2个编码（即第R*S1个后的编码）为W2
for i=1:S2,
   W2(i,1)=x(i+S1);
end
% 接着的S1个编码（即第R*S1+S1*S2个后的编码）为B1
for i=1:S1,
   B1(i,1)=x(i+S1+S2);
end
% 接着的S2个编码（即第R*S1+S1*S2+S1个后的编码）为B2
for i=1:S2,
   B2(i,1)=x(i+S1+S2+S1);
end
% 计算S1与S2层的输出
[m n] = size(P) ;
sum=0; 
SE=0; 
for i=1:n 
   x1=W1*P(i)+B1; 
   A1=tansig(x1); 
   x2=W2*A1+B2; 
   A2=purelin(x2); 
    % 计算误差平方和 
    SE=sumsqr(T(i)-A2); 
    sum=sum+SE; 
end 
val=10/sum; % 遗传算法的适应值 