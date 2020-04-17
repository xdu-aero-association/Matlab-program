%%  学习目标：使用遗传算法求解不等式
clear all
clc
A = [2 1; -1 2; 2 2];
b = [3; 2; 3];
lb = zeros(2,1);
[x,fval,exitflag] = ga(@lincontest6,2,A,b,[],[],lb)
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 
