function [KK,Bsj]=pidg(KK,Bsj)
global rin yout timef 
ts=0.001;
sys=tf(500,[1,50,1]);  % 被控对象为二阶传递函数
dsys=c2d(sys,ts,'z');  %做Z变换
[num,den]=tfdata(dsys,'v');

rin=1.0;    % 输入信号为阶跃信号 
u_1=0.0;u_2=0.0;  
y_1=0.0;y_2=0.0;
x=[0 0 0];
B=0;err_1=0;tu=1;s=0;P=100;

for k=1:P
    timef(k)=k*ts;
    r(k)=rin;
    
    u(k)=sum(KK.*x);  %控制器输出
    
    if u(k)>=10       % 约束条件
        u(k)=10;
    end
    if u(k)<=-10
        u(k)=-10;
    end
    %跟踪输入信号
    yout(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
    err(k)=r(k)-yout(k);
    %返回 PID参数
    u_2=u_1;u_1=u(k);
    y_2=y_1;y_1=yout(k);
    
    x(1)=err(k);            %计算 P
    x(2)=(err(k)-err_1)/ts; %计算 D
    x(3)=x(3)+err(k)*ts;    %计算 I
    err(2)=err_1;
    err_1=err(k);
    if s==0
        if yout(k)>0.95&yout(k)<1.05
            tu=timef(k);    % tu为上升时间
            s=1;            % 进入稳态区域
        end
    end
end

for i=1:P
    % 求代价函数值
    Ji(i)=0.999*abs(err(i))+0.01*u(i)^2*0.1;
    B=B+Ji(i);
    if i>1
        erry(i)=yout(i)-yout(i-1);  % 系统误差
        if erry(i)<0                % 若产生超调，采取惩罚措施
            B=B+100*abs(erry(i));
        end
    end
end
Bsj=B+0.2*tu*10;   % 最优代价值
