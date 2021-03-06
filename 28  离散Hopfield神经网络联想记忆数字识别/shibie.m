%% 学习目标：Hopfield神经网络的联想记忆数字识别
%%    QQ：1960009019
%%   更多matlab精彩专题课程和案例，可以搜索微信公众号：大仙一品堂
%% 清空环境变量
clc
clear
%% 数据导入
load data1 array_one
load data2 array_two
%% 训练样本（目标向量）
 T=[array_one;array_two]';
%% 创建网络
 net=newhop(T);
%% 数字1和2的带噪声数字点阵（固定法）
load data1_noisy noisy_array_one
load data2_noisy noisy_array_two
%% 数字1和2的带噪声数字点阵（随机法）

%% 数字识别

noisy_one={(noisy_array_one)'};
identify_one=sim(net,{10,10},{},noisy_one);
identify_one{10}';
noisy_two={(noisy_array_two)'};
identify_two=sim(net,{10,10},{},noisy_two);
identify_two{10}';
%% 结果显示
Array_one=imresize(array_one,20);
subplot(3,2,1)
imshow(Array_one)
title('标准(数字1)') 
Array_two=imresize(array_two,20);
subplot(3,2,2)
imshow(Array_two)
title('标准(数字2)') 
subplot(3,2,3)
Noisy_array_one=imresize(noisy_array_one,20);
imshow(Noisy_array_one)
title('噪声(数字1)') 
subplot(3,2,4)
Noisy_array_two=imresize(noisy_array_two,20);
imshow(Noisy_array_two)
title('噪声(数字2)')
subplot(3,2,5)
imshow(imresize(identify_one{10}',20))
title('识别(数字1)')
subplot(3,2,6)
imshow(imresize(identify_two{10}',20))
title('识别(数字2)')

%%


