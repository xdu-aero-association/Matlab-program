%%  学习目标：BP神经网络在人脸识别中的应用
clear all
clc;
%特征向量提取% 
%人数
M=10;
%人脸朝向类别数
N=5; 
%特征向量提取
pixel_value=extraction(M,N);
%训练集/测试集产生%
%产生图像序号的随机序列
rand_label=randperm(M*N);  
%人脸朝向标号
direction_label=[1 0 0;1 1 0;0 1 1;0 1 0;0 0 1];
%训练集
train_label=rand_label(1:30);
P_train=pixel_value(train_label,:)';
dtrain_label=train_label-floor(train_label/N)*N;
dtrain_label(dtrain_label==0)=N;
T_train=direction_label(dtrain_label,:)';
%测试集
test_label=rand_label(31:end);
P_test=pixel_value(test_label,:)';
dtest_label=test_label-floor(test_label/N)*N;
dtest_label(dtest_label==0)=N;
T_test=direction_label(dtest_label,:)'
%创建BP网络%
net=newff(minmax(P_train),[10,3],{'tansig','purelin'},'trainlm');
%设置训练参数
net.trainParam.epochs=500;
net.trainParam.show=5;
net.trainParam.goal=1e-4;
net.trainParam.lr=0.15;
t=0;
if t==0   
    %网络训练
    net=train(net,P_train,T_train);
    %仿真测试
    T_sim=sim(net,P_test);
    for i=1:3
        for j=1:20
            if T_sim(i,j)<0.5
                T_sim(i,j)=0;
            else
                T_sim(i,j)=1;
            end
        end
    end
    %比较测试样本和仿真结果的误差%
    [a,b]=size(T_sim);
    %设置识别率
    m=0;
    n=0;
    for i=1:b
        for j=1:a
            if T_sim(j,i)==T_test(j,i)
                m=m+1;
            else
                m=0;
            end
            if m==a
                n=n+1;
                m=0;
            end
        end
    end
    c=n/b;
    disp(['识别率为：' num2str(n/b*100) '%']);
    if c>0.9
        t=t+1;
    end
end
T_test
T_sim
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 