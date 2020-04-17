%% 学习目标： 基于遗传算法的PID整定
clear all
clc;
global rin yout timef  %定义全局变量

G=50;       %迭代次数
Size=30;    %种群大小
CodeL=10;   %种群个体长度（二进制编码）

MinX=zeros(1,3);      %约束条件，即kp,kd,ki 的取值范围
MaxX(1)=20*ones(1);   % kp in [0 20]
MaxX(2)=1.0*ones(1);  % kd,ki in [0 1]
MaxX(3)=1.0*ones(1);

E=round(rand(Size,3*CodeL));  %初始化种群，编码

Bsj=0;

for k=1:G          %迭代次数
    time(k)=k;
    
    for s=1:Size
        m=E(s,:);
        y1=0;y2=0;y3=0;  %输出量初始化（十进制）
        
        m1=m(1:CodeL);
        for i=1:CodeL
            y1=y1+m1(i)*2^(i-1); %计算输出量
        end
        K(s,1)=(MaxX(1)-MinX(1))*y1/1024+MinX(1); %解码，计算Kp的取值
                
        m2=m(CodeL+1:2*CodeL);
        for i=1:CodeL
            y2=y2+m2(i)*2^(i-1); %计算输出量
        end
        K(s,2)=(MaxX(2)-MinX(2))*y2/1024+MinX(2); %解码，计算Kd的取值
               
        m3=m(2*CodeL+1:3*CodeL);
        for i=1:CodeL
            y3=y3+m1(i)*2^(i-1); %计算输出量
        end
        K(s,3)=(MaxX(3)-MinX(3))*y1/1024+MinX(3); %解码，计算Ki的取值
    
    %适应度函数
    KK=K(s,:);
    [KK,Bsj]=pidg(KK,Bsj); % 调用pidg.m
    Bsji(s)=Bsj;   % 最优代价值
    end
    
    [O,D]=sort(Bsji);  %最优代价值排序
    Bestj(k)=O(1)    %取最小值
    BJ=Bestj(k);
    
  
    Ji=Bsji+1e-10;
    fi=1./Ji;          %适应函数值
    [O2,D2]=sort(fi);  %适应函数值排序
    Bestfi=O2(Size);   %取最大值
    Bests=E(D2(Size),:);

    %选择算子
    fi_sum=sum(fi);
    fi_size=(O2/fi_sum)*Size;
    fi_s=floor(fi_size);  %取较大的适应值,确定其位置
    kk=1;
    for i=1:Size
        for j=1:fi_s(i)  %选择，复制
            tempE(kk,:)=E(D2(j),:); 
            kk=kk+1;
        end
    end
    
    %交叉算子
    pc=0.6;   %交叉概率
    n=30*pc;
    for i=1:2:(Size-1)
        temp=rand;
        if pc>temp   %交叉条件
            for j=n:-1:1
                tempE(i,j)=E(i+1,j); %新、旧种群个体交叉互换
                tempE(i+1,j)=E(i,j);
            end
        end
    end
    tempE(Size,:)=Bests;
    E=tempE;
    
    %变异算子
    pm=0.001-[1:1:Size]*(0.001)/Size; %变异算子，从大到小
    for i=1:Size
        for j=1:2*CodeL
            temp=rand;
            if pm>temp  %变异条件
                if tempE(i,j)==0
                    tempE(i,j)=1;
                else
                    tempE(i,j)=0;
                end
            end
        end
    end
    tempE(Size,:)=Bests;
    E=tempE;
end

BJ,
Bestfi,
KK;
figure(1),plot(time,Bestj);
xlabel('Times');
ylabel('Best J');
figure(2),plot(timef,rin,'r',timef,yout,'b');
xlabel('Times');
ylabel('rin,yout');
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 
