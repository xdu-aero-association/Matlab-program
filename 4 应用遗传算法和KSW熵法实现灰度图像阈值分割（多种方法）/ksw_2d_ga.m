%%  学习目标：利用二维KSW熵法及传统遗传算法实现灰度图像阈值分割
%% 初始部分，读取图像及计算相关信息
clear all;
clc;
I=imread('Lenna.bmp');
windowsize=3;
I_temp=I;
for i=2:255
    for j=2:255
        I_temp(i,j)=round(mean2(I(i-1:i+1,j-1:j+1)));
    end
end
I_average=I_temp;
I_p=imadd(I,1);
I_average_p=imadd(I_average,1);
hist_2d(1:256,1:256)=zeros(256,256);
for i=1:256
    for j=1:256
        hist_2d(I_p(i,j),I_average_p(i,j))=hist_2d(I_p(i,j),I_average_p(i,j))+1;
    end
end
total=256*256;
hist_2d_1=hist_2d/total;
Hst=0;
for i=0:255
    for j=0:255
        if hist_2d_1(i+1,j+1)==0
            temp=0;
        else
            temp=hist_2d_1(i+1,j+1)*log(1/hist_2d_1(i+1,j+1));
        end
        Hst=Hst+temp;
    end
end
    %种群随机初始化，种群数取20，染色体二进制编码取16位
    t0=clock; 
    population=20;  
    X00=round(rand(1,population)*255);
    X01=round(rand(1,population)*255);   
    for i=1:population
        X0(i,:)=[X00(i) X01(i)];
    end   
    for i=1:population
        adapt_value0(i)=ksw_2d(X0(i,1),X0(i,2),0,255,hist_2d_1,Hst);
    end   
    adapt_average0=mean(adapt_value0);    
    X1=X0;
    adapt_value1=adapt_value0;
    adapt_average1=adapt_average0;   
    %循环搜索，搜索代数取200   
    generation=200;    
    for k=1:generation       
        s1=select_2d(X1,adapt_value1);   
        s_code10=dec2bin(s1(:,1),8);
        s_code11=dec2bin(s1(:,2),8);   
        [c10,c11]=cross_2d(s_code10,s_code11);   
        [v10,v11]=mutation_2d(c10,c11);   
        X20=(bin2dec(v10))';
        X21=(bin2dec(v11))';       
        for i=1:population
            X2(i,:)=[X20(i) X21(i)];
        end    
        for i=1:population
            adapt_value2(i)=ksw_2d(X2(i,1),X2(i,2),0,255,hist_2d_1,Hst);
        end  
        adapt_average2=mean(adapt_value2);   
        if abs(adapt_average2-adapt_average1)<=0.03
            break;
        else
            X1=X2;
            adapt_value1=adapt_value2;
            adapt_average1=adapt_average2; 
        end
    end    
    max_value=max(adapt_value2);
    number=find(adapt_value2==max_value);
    opt=X2(number(1),:);
    s_opt=opt(1);
    t_opt=opt(2);
    t1=clock;
    search_time=etime(t1,t0);
%阈值分割及显示部分
threshold_opt=t_opt/255;
I1=im2bw(I,threshold_opt);
figure(1);
subplot(1,2,1),
imshow(I);
title('原始灰度图');
subplot(1,2,2),
imshow(I1);
title('阈值分割后的图像');
disp('二维算法最佳阈值为：');
disp(t_opt);
disp('二维算法阈值搜索时间（s）：');
disp(search_time);    
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 