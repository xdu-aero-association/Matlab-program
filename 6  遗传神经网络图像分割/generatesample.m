function [] = generatesample( path )
%generatesample 在指定路径生成适合于训练的样本
%  path -- 指定路径，用于保存样本文件
p = [0:1:255] ;
t = zeros(1,256);
t(82:256) = 1 ;
save(path,'p','t');