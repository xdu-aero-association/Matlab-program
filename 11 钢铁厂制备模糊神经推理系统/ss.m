%% 学习目标：钢铁厂制备系统模糊神经推理系统

load('trainData.mat')    %加载数据
trainData=[X Y];         %10个样本作为训练
in_format=genfis1(trainData);
[format1,error1,stepsize]=anfis(trainData,in_format,100);    %训练100次
y1=evalfis(X,format1)                  %用训练样本仿真
y2=evalfis([42 14 12 786 3936],format1)%用评价样本仿真
plot(1:10,Y,'b--',1:10,y1,'k.')
legend('Y:训练样本','y1:验证样本' );   
xlabel('样本序号'),
ylabel('系统输出')  
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂