[x1,x2]=meshgrid(-1:0.1:1,-1:0.05:1);
y=0.5*(pi*(x1.^2)).*sin(pi*x2);
x11=reshape(x1,861,1);
x12=reshape(x2,861,1);
y1=reshape(y,861,1);
trnData=[x11(1:2:861) x12(1:2:861) y1(1:2:861)];
chkData=[x11 x12 y1];
numMFs=4;                                   %定义隶属函数个数
mfType='gbellmf';                           %定义隶属函数类型
epoch_n=30;
in_fisMat=genfis1(trnData,numMFs,mfType);
out_fisMat=anfis(trnData,in_fisMat,30);
y11=evalfis(chkData(:,1:2),out_fisMat);
x111=reshape(x11,41,21);
x112=reshape(x12,41,21);
y111=reshape(y11,41,21);
figure(1)
subplot(2,2,1),
mesh(x1,x2,y);
title('期望输出');
subplot(2,2,2),
mesh(x111,x112,y111);
title('实际输出');
subplot(2,2,3),
mesh(x1,x2,(y-y111));
title('误差');
[x,mf]=plotmf(in_fisMat,'input',1);
[x,mf1]=plotmf(out_fisMat,'input',1);
subplot(2,2,4),
plot(x,mf,'r-',x,mf1,'k--');
title('隶属度函数变化');
figure(2)
gensurf(out_fisMat)
title('推理输入输出关系图');
xlabel('输入x1');  
ylabel('输入x2'); 
zlabel('输出y');
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂