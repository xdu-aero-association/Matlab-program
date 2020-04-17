%%  声明全局变量rin yout timef，这几个变量在主程序和子函数中都可以操作
global rin yout timef 
%%   参数设置
G=100;     %%  跟后面的循环次数有关系，24行
Size=30; %  跟后面的第二十行程序参数有关系，还有嵌套的循环次数，26行
CodeL=10; %  跟后面的第二十行程序参数有关系

%%   初始化

%%   MinX()矩阵是一个1*3的一维矩阵，其值是[0,0,0]
MinX(1)=zeros(1);
MinX(2)=zeros(1);
MinX(3)=zeros(1);
%%   MaxX()矩阵是一个1*3的一维矩阵，其值是[20,1,1]
MaxX(1)=20*ones(1);
MaxX(2)=1.0*ones(1);
MaxX(3)=1.0*ones(1);

%%   round函数的作用是四舍五入
E=round(rand(Size,3*CodeL));
%%   初始化BsJ的数值，一般初始化都是0
BsJ=0;
%%  循环
for kg=1:1:G      %循环次数
    time(kg)=kg;
    for s=1:1:Size   %嵌套的循环次数
        m=E(s,:);
        y1=0;y2=0;y3=0;
        m1=m(1:1:CodeL);    %参数前面设置值
        for i=1:1:CodeL     %参数前面设置值
            y1=y1+m1(i)*2^(i-1);
        end
        KPID(s,1)=(MaxX(1)-MinX(1))*y1/1023+MinX(1);
        m2=m(CodeL+1:1:2*CodeL);
        for i=1:1:CodeL
            y2=y2+m2(i)*2^(i-1);
        end
        KPID(s,2)=(MaxX(2)-MinX(2))*y2/1023+MinX(2);
        m3=m(2*CodeL+1:1:3*CodeL);
        for i=1:1:CodeL
            y3=y3+m3(i)*2^(i-1);
        end
            KPID(s,3)=(MaxX(3)-MinX(3))*y3/1023+MinX(3);
            KPIDi=KPID(s,:);
            [KPIDi,BsJ]=chap5_3f(KPIDi,BsJ);
            BsJi(s)=BsJ;
    end

    [OderJi,IndexJi]=sort(BsJi);
    BestJ(kg)=OderJi(1);
    BJ=BestJ(kg);
    Ji=BsJi+1e-10;
    fi=1./Ji;
    [Oderfi,Indexfi]=sort(fi);
    Bestfi=Oderfi(Size);
    BestS=E(Indexfi(Size),:);

    fi_sum=sum(fi);
    fi_Size=(Oderfi/fi_sum)*Size;
    fi_S=floor(fi_Size);
    kk=1;
    for i=1:1:Size
        for j=1:1:fi_S(i)
            TempE(kk,:)=E(Indexfi(i),:);
            kk=kk+1;
        end
    end
    pc=0.60;
    n=ceil(20*rand);
    for i=1:2:(Size-1)
        temp=rand;
        if pc>temp
            for j=n:1:20
            TempE(i,j)=E(i+1,j);
            TempE(i+1,j)=E(i,j);
            end
        end
    end
    TempE(Size,:)=BestS;
    E=TempE;
    pm=0.001-[1:1:Size]*(0.001)/Size; %Bigger fi, smaller pm
    for i=1:1:Size
        for j=1:1:3*CodeL
            temp=rand;
            if pm>temp
                if TempE(i,j)==0
                    TempE(i,j)=1;
                else
                    TempE(i,j)=0;
                end
            end
        end
    end
    TempE(Size,:)=BestS;
 
    E=TempE;
end
%%  这里也只是将数值打印在命令行窗口，对程序没有什么影响
Bestfi
BestS
KPIDi
Best_J=BestJ(G)
%%  
figure(1);  %新建一个绘图界面
plot(time,BestJ,'r');%以time为横坐标，BestJ为纵坐标绘图，线条颜色为red红色
xlabel('Times');ylabel('Best J');%给图的横纵坐标表上坐标轴名称
grid on;%给图形加上网格
figure(2);%新建一个绘图界面figure(2)
plot(timef,rin,'r',timef,yout,'b');%以timef为横坐标，rin为纵坐标绘图，颜色为蓝色。并且以timef为横坐标，yout为纵坐标绘图，线条颜色为blue
xlabel('Time(s)');ylabel('rin,yout');%给图的横纵坐标表上坐标轴名称
grid on

