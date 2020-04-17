function Y = elmpredict(P,IW,B,LW,TF,TYPE)          


if nargin < 6
    error('ELM:Arguments','Not enough input arguments.');    
end
% Calculate the Layer Output Matrix H       计算隐含层输出
Q = size(P,2);
BiasMatrix = repmat(B,1,Q);
tempH = IW * P + BiasMatrix;
switch TF
    case 'sig'
        H = 1 ./ (1 + exp(-tempH));
    case 'sin'
        H = sin(tempH);
    case 'hardlim'
        H = hardlim(tempH);
end
% Calculate the Simulate Output     计算预测输出Y
Y = (H' * LW)';       %如果是回归问题就不用进行下面的了
if TYPE == 1       %如果是分类问题
    temp_Y = zeros(size(Y));
    for i = 1:size(Y,2)
        [~,index] = max(Y(:,i));
        temp_Y(index,i) = 1;
    end
    Y = vec2ind(temp_Y); 
end
       
    
