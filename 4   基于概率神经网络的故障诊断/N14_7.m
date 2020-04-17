%%  学习目标：基于概率神经网络的故障诊断

nntwarn off;
warning off;
%%  数据载入
load data

%%  选取训练数据和测试数据
Train=data(1:40,:);
Test=data(41:end,:);
p_train=Train(:,1:3)';
t_train=Train(:,4)';
p_test=Test(:,1:3)';
t_test=Test(:,4)';

%%   将期望类别转换为向量
t_train=ind2vec(t_train);
t_train_temp=Train(:,4)';

%%   使用newpnn函数建立PNN SPREAD选取为1.5
Spread=1.5;
net=newpnn(p_train,t_train,Spread)

%%  训练数据回代 查看网络的分类效果
%%   Sim函数进行网络预测
Y=sim(net,p_train);
%%   将网络输出向量转换为指针
Yc=vec2ind(Y);

%%  通过作图 观察网络对训练数据分类效果
figure(1)
subplot(1,2,1)
stem(1:length(Yc),Yc,'bo')
hold on
stem(1:length(Yc),t_train_temp,'r*')
title('训练后的效果')
xlabel('样本编号')
ylabel('分类结果')
set(gca,'Ytick',[1:5])
subplot(1,2,2)
H=Yc-t_train_temp;
stem(H)
title('训练后的误差图')
xlabel('样本编号')


%%   网络预测未知数据效果
Y2=sim(net,p_test);
Y2c=vec2ind(Y2)
figure(2)
stem(1:length(Y2c),Y2c,'b^')
hold on
stem(1:length(Y2c),t_test,'r*')
title('PNN 网络的预测效果')
xlabel('预测样本编号')
ylabel('分类结果')
set(gca,'Ytick',[1:5])
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 