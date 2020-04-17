function [Kpidi,BsJ]=pid_gaf(Kpidi,BsJ)%调用这个函数，会给主函数返回Kpidi,BsJ这两个值
%声明全局变量rin yout timef
global rin yout timef

ts=0.001;
%构建传递函数或转换为传递函数。
sys=tf(400,[1,50,0]);
%c2d函数:假设在输入端有一个零阶保持器，把连续时间的状态空间模型转到离散时间状态空间模型。
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

rin=1.0;
u_1=0.0;u_2=0.0;
y_1=0.0;y_2=0.0;
x=[0,0,0]';
B=0;
error_1=0;
tu=1;
s=0;
P=100;

for k=1:1:P
   timef(k)=k*ts;
   r(k)=rin;
   %循环对每一个u赋值
   u(k)=Kpidi(1)*x(1)+Kpidi(2)*x(2)+Kpidi(3)*x(3); 
   %对矩阵u的每一个数值进行限幅
   if u(k)>=10
      u(k)=10;
   end
   if u(k)<=-10
      u(k)=-10;
   end   
   
   yout(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
   error(k)=r(k)-yout(k);
%------------ Return of PID parameters -------------
   u_2=u_1;u_1=u(k);
   y_2=y_1;y_1=yout(k);
   
   x(1)=error(k);                % 计算 P
   x(2)=(error(k)-error_1)/ts;   % 计算 D
   x(3)=x(3)+error(k)*ts;        % 计算 I
   
   error_2=error_1;
   error_1=error(k);
    if s==0
       if yout(k)>0.95 && yout(k)<1.05
          tu=timef(k);
          s=1;
       end 
    end
end

for i=1:1:P
    %abs函数的作用是取绝对值
   Ji(i)=0.999*abs(error(i))+0.01*u(i)^2*0.1;
   B=B+Ji(i);   
   if i>1   
       erry(i)=yout(i)-yout(i-1);
       if erry(i)<0
          B=B+100*abs(erry(i));
       end
   end
end
%给主函数返回BsJ的值
BsJ=B+0.2*tu*10;