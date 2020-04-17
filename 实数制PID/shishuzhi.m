%%  GA(Generic Algorithm) Program to optimize PID Parameters
clc
clear all
close all
%%  声明全局变量rin yout timef，这几个变量在主程序和子函数中都可以操作
global rin yout timef

%% 设值
Size=30;
CodeL=3;

%%  初始化

%%  MinX()矩阵是一个1*3的一维矩阵，其值是[0,0,0]
MinX(1)=zeros(1);
MinX(2)=zeros(1);
MinX(3)=zeros(1);
%%  MaxX()矩阵是一个1*3的一维矩阵，其值是[20,1,1]
MaxX(1)=20*ones(1);
MaxX(2)=1.0*ones(1);
MaxX(3)=1.0*ones(1);
%%  KPID矩阵是一个30行3列的矩阵
KPID(:,1)=MinX(1)+(MaxX(1)-MinX(1))*rand(Size,1);%给KPID矩阵的第1列赋值
KPID(:,2)=MinX(2)+(MaxX(2)-MinX(2))*rand(Size,1);%给KPID矩阵的第2列赋值
KPID(:,3)=MinX(3)+(MaxX(3)-MinX(3))*rand(Size,1);%给KPID矩阵的第3列赋值

G=100;
BsJ=0;

for kg=1:1:G        %for循环，kg从1到100，每循环一次就加1
    time(kg)=kg;%循环给time矩阵的每个值赋值
    
    %每次循环一个kg，这里都要完成一个完整的i从1到Size的循环
    for i=1:1:Size
        KPIDi=KPID(i,:);

        [KPIDi,BsJ]=chap5_3f(KPIDi,BsJ);

        BsJi(i)=BsJ;
    end
    %sort函数沿着大小不等于1的第一个数组维以升序排列BsJi的元素。
    [OderJi,IndexJi]=sort(BsJi);
    BestJ(kg)=OderJi(1);
    BJ=BestJ(kg);
    Ji=BsJi+1e-10;    
    fi=1./Ji;
    %  Cm=max(Ji);
    %  fi=Cm-Ji;                     
    %sort函数沿着大小不等于1的第一个数组维以升序排列fi的元素。
    [Oderfi,Indexfi]=sort(fi);       
    Bestfi=Oderfi(Size);          
    BestS=KPID(Indexfi(Size),:);  
    %这一句只是显示fi矩阵中的最大值，对程序没有影响
    max(fi)
   
%    kg   
%    BJ
%    BestS
    %对矩阵fi求和
    fi_sum=sum(fi);
    fi_Size=(Oderfi/fi_sum)*Size;
    %floor函数将A的元素四舍五入为小于或等于A的最近整数。
    fi_S=floor(fi_Size);                    
    r=Size-sum(fi_S);
   
    Rest=fi_Size-fi_S;
    %sort函数沿着大小不等于1的第一个数组维以升序排列BsJi的元素。
    [RestValue,Index]=sort(Rest);
   
    for i=Size:-1:Size-r+1
        fi_S(Index(i))=fi_S(Index(i))+1;     
    end

    k=1;
    for i=Size:-1:1         
        for j=1:1:fi_S(i)  
            TempE(k,:)=KPID(Indexfi(i),:);       
            k=k+1;                            
        end
    end
   
    Pc=0.90;
    for i=1:2:(Size-1)
          temp=rand;
          %如果Pc大于temp,就进行以下的赋值
      if Pc>temp                      
          alfa=rand;
          TempE(i,:)=alfa*KPID(i+1,:)+(1-alfa)*KPID(i,:);  
          TempE(i+1,:)=alfa*KPID(i,:)+(1-alfa)*KPID(i+1,:);
      end
    end
    TempE(Size,:)=BestS;
    KPID=TempE;
    
    Pm=0.10-[1:1:Size]*(0.01)/Size;      
    Pm_rand=rand(Size,CodeL);
    Mean=(MaxX + MinX)/2; 
    Dif=(MaxX-MinX);

   for i=1:1:Size
      for j=1:1:CodeL
         if Pm(i)>Pm_rand(i,j)        
            TempE(i,j)=Mean(j)+Dif(j)*(rand-0.5);
         end
      end
   end
    %Guarantee TempE(Size,:) belong to the best individual
    %保证TempE矩阵中的数值是最优化最好的
   TempE(Size,:)=BestS;      
   KPID=TempE;
end
%这里也只是将数值打印在命令行窗口，对程序没有什么影响
Bestfi
BestS
Best_J=BestJ(G);
%新建一个绘图界面
figure(1);
%以time为横坐标，BestJ为纵坐标绘图
plot(time,BestJ);
%给图的横纵坐标表上坐标轴名称
xlabel('Times');ylabel('Best J');
figure(2);%新建一个绘图界面figure(2)
%以timef为横坐标，rin为纵坐标绘图，颜色为red。并且以timef为横坐标，yout为纵坐标绘图，线条颜色为blue
plot(timef,rin,'r',timef,yout,'b');
%给图的横纵坐标表上坐标轴名称
xlabel('Time(s)');ylabel('rin,yout');
