%%  学习目标：免疫遗传算法实现图像阈值分割
clear all
clc
tic
%%  
popsize=15;       %群体规模
lanti=10;       
maxgen=50;        %最大代数
cross_rate=0.4;   %交叉速率
mutation_rate=0.1;%变异速率
a0=0.7;
zpopsize=5;
bestf=0;
nf=0;
number=0;
%%  
I=imread('01.bmp');   %读入图像

%%  
q=isrgb(I);             %判断是否为RGB真彩图像
if q==1 
    I=rgb2gray(I);      %转换RGB图像为灰度图像
end
%%  
[m,n]=size(I);            %图像大小
p=imhist(I);              %显示图像数据直方图
p=p';                     %阵列由列变为行
p=p/(m*n);                %将p的值变换到（0,1）
figure(1)
subplot(1,2,1);
imshow(I);
title('原图的灰度图像');
hold on
%%  抗体群体初始化
pop=2*rand(popsize,lanti)-1;   %pop为15*10的值为（-1,1）之间的随机数矩阵
pop=hardlim(pop);              %大于等于0为1，小于0为0
%%   免疫操作
for gen=1:maxgen   
    %%  计算抗体—抗原的亲和度
  [fitness,yuzhi,number]=fitnessty(pop,lanti,I,popsize,m,n,number);
  if max(fitness)>bestf
    bestf=max(fitness);
    nf=0;
  for i=1:popsize
      %%  找出最大适应度在向量fitness中的序号
        if fitness(1,i)==bestf        
            v=i;
        end
  end
 yu=yuzhi(1,v);
  elseif max(fitness)==bestf
    nf=nf+1;
  end
    if nf>=20
     break;
    end
%%  
A=shontt(pop);                     %计算抗体—抗体的相似度
f=fit(A,fitness);                  %计算抗体的聚合适应度
pop=select(pop,f);                 %进行选择操作
pop=coss(pop,cross_rate,popsize,lanti);  %交叉
pop=mutation_compute(pop,mutation_rate,lanti,popsize);   %变异
a=shonqt(pop); %计算抗体群体的相似度
%% 
if a>a0
    zpop=2*rand(zpopsize,lanti)-1;
    zpop=hardlim(zpop);                %随机生成zpopsize个新抗体
    pop(popsize+1:popsize+zpopsize,:)=zpop(:,:);
    [fitness,yuzhi,number]=fitnessty(pop,lanti,I,popsize,m,n,number);              
    %%  计算抗体—抗原的亲和度
    A=shontt(pop);                     %计算抗体—抗体的相似度
    f=fit(A,fitness);                  %计算抗体的聚合适应度
    pop=select(pop,f);                 %进行选择操作
end
if gen==maxgen
   [fitness,yuzhi,number]=fitnessty(pop,lanti,I,popsize,m,n,number);              
   %计算抗体—抗原的亲和度 
end
end
imshow(I);
subplot(1,2,2);
fresult(I,yu);
title('阈值分割后的图像');

%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 