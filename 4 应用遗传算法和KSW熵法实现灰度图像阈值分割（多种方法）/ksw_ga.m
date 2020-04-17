%%  利用KSW熵法及传统遗传算法实现灰度图像阈值分割
%%初始部分，读取图像及计算相关信息
clear all;
clc;
I=imread('Lenna.bmp');
hist=imhist(I);
total=0;
for i=0:255
    total=total+hist(i+1);
end
hist1=hist/total;

HT=0;
for i=0:255
    if hist1(i+1)==0
        temp=0;
    else
        temp=hist1(i+1)*log(1/hist1(i+1));
    end
    HT=HT+temp;
end
    %种群随机初始化，种群数取10，染色体二进制编码取8位
    t0=clock;
    population=10;  
    X0=round(rand(1,population)*255);
    for i=1:population
        adapt_value0(i)=ksw(X0(i),0,255,hist1,HT);
    end
    adapt_average0=mean(adapt_value0);    
    X1=X0;
    adapt_value1=adapt_value0;
    adapt_average1=adapt_average0;    
    %循环搜索，搜索代数取200    
    generation=200;   
    for k=1:generation       
        s1=select_ga(X1,adapt_value1);   
        s_code1=dec2bin(s1,8);   
        c1=cross_ga(s_code1);   
        v1=mutation_ga(c1);    
        X2=(bin2dec(v1))';    
        for i=1:population
            adapt_value2(i)=ksw(X2(i),0,255,hist1,HT);
        end    
        adapt_average2=mean(adapt_value2);    
        if abs(adapt_average2-adapt_average1)<=0.1
            break;
        else
            X1=X2;
            adapt_value1=adapt_value2;
            adapt_average1=adapt_average2; 
        end
    end   
    max_value=max(adapt_value2);
    number=find(adapt_value2==max_value);
    t_opt=round(mean(X2(number)));
t1=clock;
search_time=etime(t1,t0);
%结果显示
threshold_opt=t_opt/255;
I1=im2bw(I,threshold_opt);
figure(1);
subplot(1,2,1),
imshow(I);
title('原始灰度图');
subplot(1,2,2),
imshow(I1);
title('阈值分割后的图像');
disp('算法最佳阈值为：');
disp(t_opt);
disp('算法阈值搜索时间（s）：');
disp(search_time);