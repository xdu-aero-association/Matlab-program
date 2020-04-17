%% 学习目标：ELman神经网络预测数据
%%    QQ：1960009019
%%   更多matlab精彩专题课程和案例，可以搜索微信公众号：大仙一品堂
data=[0.4 0.5 0.5 0.45;0.5 0.56 0.54 0.45;0.4 0.5 0.5 0.45;0.5 0.56 0.54 0.45;0.5 0.56 0.54 0.45;0.4 0.5 0.5 0.75;0.5 0.46 0.54 0.45]
net=[];
for i=1:4
P=[data(1:3,i),data(2:4,i),data(3:5,i)];
T=[data(4,i),data(5,i),data(6,i)];
th1=[0,1;0,1;0,1];
th2=[0,1];
net{i}=newelm(th1,th2,[20,1]);
net{i}=init(net{i});
net{i}=train(net{i},P,T);
test_p{i}=data(4:6,i);
y(i)=sim(net{i},test_p{i});
end
fprintf('真实值:\n');
disp(data(7,:));
fprintf('预测值:\n');
disp(y);
fprintf('误差:\n');
disp((y-data(7,:))./y);