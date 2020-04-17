%%  学习目标：国际航空小姐选拔模糊控制推理系统

fisMat=newfis('ex');
fisMat=addvar(fisMat,'input','英语成绩',[0  100]);
fisMat=addvar(fisMat,'input','身高',[0  10]);
fisMat=addvar(fisMat,'output','通过率',[0  100]);

fisMat=addmf(fisMat,'input',1,'差','trapmf',[0 0 60 80]);
fisMat=addmf(fisMat,'input',1,'好','trapmf',[60 80 100 100]);

fisMat=addmf(fisMat,'input',2,'正常','trimf',[0 1 5]);
fisMat=addmf(fisMat,'input',2,'高','trapmf',[1 5 10 10]);

fisMat=addmf(fisMat,'output',1,'低','trimf',[0 30 50]);
fisMat=addmf(fisMat,'output',1,'正常','trimf',[30 50 80]);
fisMat=addmf(fisMat,'output',1,'高','trimf',[50 80 100]);
rulelist=[1 2 3 1 1; 2 2 1 1 1; 0 1 2 1 0];
fisMat=addrule(fisMat,rulelist);
gensurf(fisMat);
in=[60 1.5;90 1.6];
out=evalfis(in,fisMat)
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂