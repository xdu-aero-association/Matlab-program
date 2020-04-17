%%  学习目标：函数gaussmf建立高斯型隶属度函数

x = 0:0.1:10;
y = gaussmf(x,[2 5]);
plot(x,y)
xlabel('函数输入值')
ylabel('函数输出值')
grid on
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂