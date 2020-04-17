%%  学习目标：遗传算法道路图像阈值分割
function main()
clear all
close all
clc
global chrom oldpop fitness lchrom  popsize cross_rate mutation_rate thresholdsum
global maxgen  m n fit gen threshold A B C oldpop1 popsize1 b b1 fitness1 threshold1
A=imread('1.jpg');     %读入道路图像
A=imresize(A,0.5);     %利用imresize函数通过默认的最近邻插值将图像放大0.5倍
B=rgb2gray(A);         %灰度化
C=imresize(B,0.2);     %将读入的图像缩小到0.2倍
lchrom=10;              %染色体长度
popsize=10;            %种群大小
cross_rate=0.8;        %交叉概率
mutation_rate=0.5;     %变异概率
maxgen=100;            %最大代数
[m,n]=size(C);
initpop;    %初始种群
for gen=1:maxgen
    generation;  %遗传操作
end
findthreshold_best; %图象分割结果
%%%%%%%%%%%%%%%%%%%输出进化各曲线%%%%%%%%%%%
figure;
gen=1:maxgen;
plot(gen,fit(1,gen)); 
title('最佳适应度值进化曲线');
xlabel('代数'),
ylabel('最佳适应度值')
figure;
plot(gen,threshold(1,gen));
title('每一代的最佳阈值变化曲线');
xlabel('代数'),
ylabel('每一代的最佳阈值')
%%%%%%%%%%%%%%%%%%%初始化种群%%%%%%%%%%%%%%%%%%%%
function initpop()
global lchrom oldpop popsize chrom C
imshow(C);
for i=1:popsize
    chrom=rand(1,lchrom);
    for j=1:lchrom
        if chrom(1,j)<0.5
            chrom(1,j)=0;
       else 
           chrom(1,j)=1;
        end
    end
    oldpop(i,1:lchrom)=chrom;    %给每一个个体分配8位的染色体编码
end

%%%%%%%%%%%%%%%%%产生新一代个体%%%%%%%%%%%%%%%%%%%%%%
function generation()
fitness_order;                  %计算适应度值及排序
select;                         %选择操作
crossover;                      %交叉
mutation;                       %变异
%%%%%%%%%%%%%%%%%计算适度值并且排序%%%%%%%%%%%%%%%%%%%
function fitness_order()
global lchrom oldpop fitness popsize chrom fit gen C m n  fitness1 thresholdsum
global lowsum higsum u1 u2 threshold gen oldpop1 popsize1 b1 b threshold1 
if popsize>=5
    popsize=ceil(popsize-0.03*gen);
end
if gen==75     %当进化到末期的时候调整种群规模和交叉、变异概率
    cross_rate=0.3;        %交叉概率
    mutation_rate=0.3;     %变异概率
end
%如果不是第一代则将上一代操作后的种群根据此代的种群规模装入此代种群中
if gen>1   
    t=oldpop;
    j=popsize1;
    for i=1:popsize
        if j>=1
            oldpop(i,:)=t(j,:);
        end
        j=j-1;
    end
end
%计算适度值并排序
for i=1:popsize
    lowsum=0;
    higsum=0;
    lownum=0;
    hignum=0;
    chrom=oldpop(i,:);
    c=0;
    for j=1:lchrom
        c=c+chrom(1,j)*(2^(lchrom-j));
    end
    b(1,i)=c*255/(2^lchrom-1);  %转化到灰度值        
    for x=1:m
        for y=1:n
            if C(x,y)<=b(1,i)
                lowsum=lowsum+double(C(x,y));%统计低于阈值的灰度值的总和
                lownum=lownum+1; %统计低于阈值的灰度值的像素的总个数
            else
                higsum=higsum+double(C(x,y));%统计高于阈值的灰度值的总和
                hignum=hignum+1; %统计高于阈值的灰度值的像素的总个数
            end
        end
    end
    if lownum~=0
        u1=lowsum/lownum; %u1、u2为对应于两类的平均灰度值
    else
        u1=0;
    end
    if hignum~=0
        u2=higsum/hignum;
    else
        u2=0;
    end   
    fitness(1,i)=lownum*hignum*(u1-u2)^2; %计算适度值
end
if gen==1 %如果为第一代，从小往大排序
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(1,i);
                b(1,i)=b(1,j);
                b(1,j)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
    for i=1:popsize
        fitness1(1,i)=fitness(1,i);
        b1(1,i)=b(1,i);
        oldpop1(i,:)=oldpop(i,:);
    end
    popsize1=popsize;
else %大于一代时进行如下从小到大排序
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(1,i);
                b(1,i)=b(1,j);
                b(1,j)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
end 
%下边对上一代群体进行排序
for i=1:popsize1
    j=i+1;
    while j<=popsize1
        if fitness1(1,i)>fitness1(1,j)
            tempf=fitness1(1,i);
            tempc=oldpop1(i,:);
            tempb=b1(1,i);
            b1(1,i)=b1(1,j);
            b1(1,j)=tempb;
            fitness1(1,i)=fitness1(1,j);
            oldpop1(i,:)=oldpop1(j,:);
            fitness1(1,j)=tempf;
            oldpop1(j,:)=tempc;
        end
        j=j+1;
    end
end
%下边统计每一代中的最佳阈值和最佳适应度值
if gen==1
    fit(1,gen)=fitness(1,popsize);
    threshold(1,gen)=b(1,popsize);
    thresholdsum=0;
else
    if fitness(1,popsize)>fitness1(1,popsize1)
        threshold(1,gen)=b(1,popsize); %每一代中的最佳阈值
        fit(1,gen)=fitness(1,popsize);%每一代中的最佳适应度
    else
        threshold(1,gen)=b1(1,popsize1); 
        fit(1,gen)=fitness1(1,popsize1);
    end
end

%%%%%%%%%%%%%%%%%%%精英选择%%%%%%%%%%%%%%%%%%%%
function select()
global fitness popsize oldpop temp popsize1 oldpop1 gen b b1 fitness1
%统计前一个群体中适应值比当前群体适应值大的个数
s=popsize1+1;
for j=popsize1:-1:1
    if fitness(1,popsize)<fitness1(1,j)
        s=j;
    end
end
for i=1:popsize
    temp(i,:)=oldpop(i,:);
end
if s~=popsize1+1
    if gen<50  %小于50代用上一代中用适应度值大于当前代的个体随机代替当前代中的个体
        for i=s:popsize1
            p=rand;
            j=floor(p*popsize+1);
            temp(j,:)=oldpop1(i,:);
            b(1,j)=b1(1,i);
            fitness(1,j)=fitness1(1,i);
        end
    else
        if gen<100  %50~100代用上一代中用适应度值大于当前代的个体代替当前代中的最差个体
            j=1;
            for i=s:popsize1
                temp(j,:)=oldpop1(i,:);
                b(1,j)=b1(1,i);
                fitness(1,j)=fitness1(1,i);
                j=j+1;
            end
        else %大于100代用上一代中的优秀的一半代替当前代中的最差的一半，加快寻优
            j=popsize1;
            for i=1:floor(popsize/2)
                temp(i,:)=oldpop1(j,:);
                b(1,i)=b1(1,j);
                fitness(1,i)=fitness1(1,j);
                j=j-1;
            end
        end
    end
end
%将当前代的各项数据保存
for i=1:popsize
    b1(1,i)=b(1,i); 
end    
for i=1:popsize
    fitness1(1,i)=fitness(1,i); 
end
for i=1:popsize
    oldpop1(i,:)=temp(i,:);
end
popsize1=popsize;
%%%%%%%%%%%%%交叉%%%%%%%%%%%%%%%%%%%%%%%%%%
function crossover()
global temp popsize cross_rate lchrom
j=1;
for i=1:popsize
    p=rand;
    if p<cross_rate
        parent(j,:)=temp(i,:);
        a(1,j)=i;
        j=j+1;
    end
end
j=j-1;
if rem(j,2)~=0
    j=j-1;
end
if j>=2
    for k=1:2:j
        cutpoint=round(rand*(lchrom-1));
        f=k;
        for i=1:cutpoint
            temp(a(1,f),i)=parent(f,i);
            temp(a(1,f+1),i)=parent(f+1,i);
        end
        for i=(cutpoint+1):lchrom
            temp(a(1,f),i)=parent(f+1,i);
            temp(a(1,f+1),i)=parent(f,i);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%变异%%%%%%%%%%%%%%%%%%%%%
function mutation()
global popsize lchrom mutation_rate temp newpop oldpop
sum=lchrom*popsize;    %总基因个数
mutnum=round(mutation_rate*sum);    %发生变异的基因数目
for i=1:mutnum
    s=rem((round(rand*(sum-1))),lchrom)+1; %确定所在基因的位数
    t=ceil((round(rand*(sum-1)))/lchrom); %确定变异的是哪个基因
    if t<1
        t=1;
    end
    if t>popsize
        t=popsize;
    end
    if s>lchrom
        s=lchrom;
    end
    if temp(t,s)==1
        temp(t,s)=0;
    else
        temp(t,s)=1;
    end
end
for i=1:popsize
    oldpop(i,:)=temp(i,:);
end
%%%%%%%%%%%%%%%%%%%%%%查看结果%%%%%%%%%%%%%%%%%%%%
function findthreshold_best()
global maxgen threshold m n C B A 
threshold_best=floor(threshold(1,maxgen)) %threshold_best为最佳阈值
C=imresize(B,0.3);
figure
subplot(1,2,1)
imshow(A);
title('原始道路图像')
subplot(1,2,2)
imshow(C);
title('原始道路的灰度图')
figure;
subplot(1,2,1)
imshow(C);
title('原始道路的灰度图')
[m,n]=size(C);
%用所找到的阈值分割图象
for i=1:m
    for j=1:n
        if C(i,j)<=threshold_best
            C(i,j)=0;
        else
            C(i,j)=255;
        end
    end
end
subplot(1,2,2)
imshow(C);
title('阈值分割后的道路图');
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 