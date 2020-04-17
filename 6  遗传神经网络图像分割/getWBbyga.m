function [ W1, B1, W2, B2 ] = getWBbyga(paraments )
%getWBbyga 用遗传算法获取神经网络权值阈值参数
%  paraments 为遗传算法的参数信息.[遗传代数 最小适应值]。

Generations = 100;
fitnesslimit = -Inf ;
if(nargin > 0)
    Generations  = paraments(1);
    fitnesslimit = paraments(2);
end

[P,T,R,S1,S2,S]=nninit;
FitnessFunction = @gafitness;
numberOfVariables = S;
opts = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotstopping},'Generations',Generations,'FitnessLimit',fitnesslimit);
[x,Fval,exitFlag,Output] = ga(FitnessFunction,numberOfVariables,opts);
[W1, B1, W2, B2, P, T, A1, A2, SE, val]=gadecod(x);