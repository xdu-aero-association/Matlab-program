%%  学习目标：建立一般的钟型隶属度函数gbellmf

x = 0:0.1:10;
y = gbellmf(x,[2 4 6]);
plot(x,y)
xlabel('函数输入值')
ylabel('函数输出值')
grid on
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂