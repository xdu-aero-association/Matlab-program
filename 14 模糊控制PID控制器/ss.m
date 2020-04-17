%%  学习目标：模糊控制PID控制器设计
clear all
clc
%使用MOM算法（取隶属度最大的那个数）
a=newfis('fuzzf');
f1=1;
a=addvar(a,'input','e',[-3*f1,3*f1]);
a=addmf(a,'input',1,'NB','zmf',[-3*f1,-1*f1]);
a=addmf(a,'input',1,'NM','trimf',[-3*f1,-2*f1,0]);
a=addmf(a,'input',1,'NS','trimf',[-3*f1,-1*f1,1*f1]);
a=addmf(a,'input',1,'Z','trimf',[-2*f1,0,2*f1]);
a=addmf(a,'input',1,'PS','trimf',[-1*f1,1*f1,3*f1]);
a=addmf(a,'input',1,'PM','trimf',[0,2*f1,3*f1]);
a=addmf(a,'input',1,'PB','smf',[1*f1,3*f1]);
f2=1;
a=addvar(a,'input','ec',[-3*f2,3*f2]);
a=addmf(a,'input',2,'NB','zmf',[-3*f2,-1*f2]);
a=addmf(a,'input',2,'NM','trimf',[-3*f2,-2*f2,0]);
a=addmf(a,'input',2,'NS','trimf',[-3*f2,-1*f2,1*f2]);
a=addmf(a,'input',2,'Z','trimf',[-2*f2,0,2*f2]);
a=addmf(a,'input',2,'PS','trimf',[-1*f2,1*f2,3*f2]);
a=addmf(a,'input',2,'PM','trimf',[0,2*f2,3*f2]);
a=addmf(a,'input',2,'PB','smf',[1*f2,3*f2]);
f3=1.5;
a=addvar(a,'output','u',[-3*f3,3*f3]);
a=addmf(a,'output',1,'NB','zmf',[-3*f3,-1*f3]);
a=addmf(a,'output',1,'NM','trimf',[-3*f3,-2*f3,0]);
a=addmf(a,'output',1,'NS','trimf',[-3*f3,-1*f3,1*f3]);
a=addmf(a,'output',1,'Z','trimf',[-2*f3,0,2*f3]);
a=addmf(a,'output',1,'PS','trimf',[-1*f3,1*f3,3*f3]);
a=addmf(a,'output',1,'PM','trimf',[0,2*f3,3*f3]);
a=addmf(a,'output',1,'PB','smf',[1*f3,3*f3]);
%规则
rulelist=[1 1 1 1 1;
    1 2 1 1 1;
    1 3 2 1 1;
    1 4 2 1 1;
    1 5 3 1 1;
    1 6 3 1 1;
    1 7 4 1 1;
    
    2 1 1 1 1;
    2 2 2 1 1;
    2 3 2 1 1;
    2 4 3 1 1;
    2 5 3 1 1;
    2 6 4 1 1;
    2 7 5 1 1;
    
    3 1 2 1 1;
    3 2 2 1 1;
    3 3 3 1 1;
    3 4 3 1 1;
    3 5 4 1 1;
    3 6 5 1 1;
    3 7 5 1 1;
    
    4 1 2 1 1;
    4 2 3 1 1;
    4 3 3 1 1;
    4 4 4 1 1;
    4 5 5 1 1;
    4 6 5 1 1;
    4 7 6 1 1;
    
    5 1 3 1 1;
    5 2 3 1 1;
    5 3 4 1 1;
    5 4 5 1 1;
    5 5 5 1 1;
    5 6 6 1 1;
    5 7 6 1 1;
    
    6 1 3 1 1;
    6 2 4 1 1;
    6 3 5 1 1;
    6 4 5 1 1;
    6 5 6 1 1;
    6 6 6 1 1;
    6 7 7 1 1;
    
    7 1 4 1 1;
    7 2 5 1 1;
    7 3 5 1 1;
    7 4 6 1 1;
    7 5 6 1 1;
    7 6 7 1 1;
    7 7 7 1 1];
a=addrule(a,rulelist);
a1=setfis(a,'DefuzzMethod','mom');
writefis(a1,'fuzzf');
a2=readfis('fuzzf');
Ulist=zeros(7,7);
for i=1:7
    for j=1:7
        e(i)=-4+i;
        ec(j)=-4+j;
        Ulist(i,j)=evalfis([e(i),ec(j)],a2);
    end
end
figure(1);
plotfis(a2);
title('模糊控制器内部原理图')
figure(2);
plotmf(a,'input',1);
title('输入1图形')
xlabel('e','fontsize',10);
ylabel('隶属度函数','fontsize',10);
figure(3);
plotmf(a,'input',2);
title('输入2图形')
xlabel('ec','fontsize',10);
ylabel('隶属度函数','fontsize',10);
figure(4);
plotmf(a,'output',1);
title('隶属度函数图')
xlabel('u','fontsize',10);
ylabel('隶属度函数','fontsize',10);
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂