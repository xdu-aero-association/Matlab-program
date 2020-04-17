function [IW,B,LW,TF,TYPE] = elmtrain(P,T,N,TF,TYPE)    %P  输入矩阵   T   输出矩阵    N    隐含神经元个数 TF    传递函数   TYPE  0 回归还是分类 1
%IW    隐含层和输入层的连接权值   B  隐含层神经元阈值     LW 通过解方程组得到的隐含层和输出层的连接权值    TF
%TYPE   一样，预测要用。一并返回来
if nargin < 2   %调用函数的参数个数小于2
    error('ELM:Arguments','Not enough input arguments.');   %提示错误，最少两个参数
end
if nargin < 3
    N = size(P,2);          %神经元个数等于输入的样本数
end
if nargin < 4
    TF = 'sig';    %默认  sig
end
if nargin < 5
    TYPE = 0;   %默认回归问题
end
if size(P,2) ~= size(T,2)      %检测  列数   也就是样本数是否相等
    error('ELM:Arguments','The columns of P and T must be same.');     %不相等的话提示出错
end
[R,Q] = size(P);
if TYPE  == 1
    T  = ind2vec(T);        
end
[S,Q] = size(T);          

IW = rand(N,R) * 2 - 1;    %随机产生隐含层和输入层的连接权值

B = rand(N,1);            %随机产生阈值
BiasMatrix = repmat(B,1,Q);    

tempH = IW * P + BiasMatrix;         %得到神经元的输入
switch TF                     %通过激活函数得到隐含层的输出
    case 'sig'
        H = 1 ./ (1 + exp(-tempH));
    case 'sin'
        H = sin(tempH);
    case 'hardlim'
        H = hardlim(tempH);
end

LW = pinv(H') * T';    %通过求解weini   得到  隐含层和输出层的连接权值
