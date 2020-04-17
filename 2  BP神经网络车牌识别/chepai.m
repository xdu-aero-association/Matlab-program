%%   清空环境变量和命令窗口
clc;     
clear;
close all;
%%  定义全局变量A
global A
%%   读入车牌图片并显示
I=imread('1.png');
figure(1),imshow(I);title('原图');
%%  
        if length(size(I))==3
            I1 = rgb2gray(I);    %转换为灰度图
        else
           I1 =I;
        end
figure(2),subplot(1,2,1),imshow(I1);title('灰度图');
figure(2),subplot(1,2,2),imhist(I1);title('灰度图直方图');
%%  canny算子边缘检测
I2=edge(I1,'canny',[0.2,0.55]);
figure(3),imshow(I2);title('canny算子边缘检测')
%%  腐蚀
se=[1;1;1];
I3=imerode(I2,se);         
figure(4),imshow(I3);title('腐蚀后图像');
%%  平滑
se=strel('rectangle',[40,40]);
I4=imclose(I3,se);
figure(5),imshow(I4);title('平滑图像的轮廓');
%% 从对象中移除小对象 
I5=bwareaopen(I4,2000);
figure(6),imshow(I5);
title('从对象中移除小对象');
[y,x,z]=size(I5);
myI=double(I5);
%%   begin横向扫描
     Blue_y=zeros(y,1);
      for i=1:y
         for j=1:x
             if(myI(i,j,1)==1) 
          %如果myI(i,j,1)即myI图像中坐标为(i,j)的点为蓝色
          %则Blue_y的相应行的元素white_y(i,1)值加1
           Blue_y(i,1)= Blue_y(i,1)+1;         %蓝色像素点统计 
             end  
         end    
      end
[temp MaxY]=max(Blue_y);
%temp为向量white_y的元素中的最大值，MaxY为该值的索引（ 在向量中的位置）
PY1=MaxY;
     while ((Blue_y(PY1,1)>=50)&&(PY1>1))
          PY1=PY1-1;
     end    
 PY2=MaxY;
     while ((Blue_y(PY2,1)>=10)&&(PY2<y))
        PY2=PY2+1;
     end
     IY=I(PY1:PY2,:,:);
%IY为原始图像I中截取的纵坐标在PY1：PY2之间的部分
 %end横向扫描
 %%   begin纵向扫描
      Blue_x=zeros(1,x);   %进一步确定x方向的车牌区域
 for j=1:x
         for i=PY1:PY2
             if(myI(i,j,1)==1)
                  Blue_x(1,j)= Blue_x(1,j)+1;               
             end  
         end       
 end
 PX1=1;
      while ((Blue_x(1,PX1)<3)&&(PX1<x))
          PX1=PX1+1;
      end    
 PX2=x;
      while ((Blue_x(1,PX2)<3)&&(PX2>PX1))
             PX2=PX2-1;
      end 
 PX1=PX1-1;
 PX2=PX2+15;
 PY1=PY1-2.5;
 %end纵向扫描
 dw=I(PY1:PY2,PX1:PX2,:);
 imwrite(dw,'dw.jpg'); %将图像数据写入图像中
figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');
figure(7),subplot(1,2,2),imshow(dw),title('定位剪切后的彩色车牌图像')
%%   利用radon变换做水平矫正
bw=rgb2gray(dw);
bw1=edge(bw,'sobel','horizontal');
theta=0:179;
r=radon(bw1,theta);
[m,n]=size(r);
c=1;
for i=1:m
    for j=1:n
        if r(1,1)<r(i,j)
            r(1,1)=r(i,j);
            c=j;
        end
    end
end
rot=90-c+2;
pic=imrotate(bw,rot,'crop');
figure(8),subplot(3,1,1),imshow(bw),title('1.定位后的这牌灰度图像');


figure(8),subplot(3,1,2),imshow(pic),title('2.利用radon算子做水平方向矫正');
%%  利用radon变换做垂直方向的矫正
binaryImage = edge(pic,'canny'); 
binaryImage = bwmorph(binaryImage,'thicken'); 
theta = -90:89;
[R,xp] = radon(binaryImage,theta);

[R1,r_max] = max(R);
theta_max = 90;
while (theta_max > 50 || theta_max<-50)
    [R2,theta_max] = max(R1);                      
    R1(theta_max) = 0; 
    theta_max = theta_max - 91;
end
%角度计算完毕
H=[1,0,0; tan(-theta_max),1,0;0,0,1];
T=maketform('affine',H);
pic=imtransform(pic,T);
figure(8),subplot(3,1,3), imshow(pic);title('3.利用radon算子做垂直方向矫正');


%%   字符分割前的预处理
g_max=double(max(max(pic)));
g_min=double(min(min(pic)));
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值
[m,n]=size(pic);
d=im2bw(pic,T/256);              % d:二值图像
figure(9);subplot(2,2,1),imshow(d),title('1.车牌二值图像')
%%   滤波
h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));
figure(9),subplot(2,2,2),imshow(d),title('2.均值滤波后')
%%   某些图像进行操作
%%   膨胀或腐蚀
se=strel('square',3); % 使用一个3X3的正方形结果元素对象对创建的图像膨胀
se=eye(2);        % eye(n) returns the n-by-n identity matrix 单位矩阵
[m,n]=size(d);
if bwarea(d)/m/n>=0.365
       d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
       d=imdilate(d,se);
end
figure(9),subplot(2,2,3),imshow(d),title('3.膨胀或腐蚀处理后')

%%  对图像的边框进行裁剪，只留下有效字符部分
[y1,x1,z1]=size(d);
    
I3=double(d);
TT=1;
Y1=zeros(y1,1);
 for i=1:y1
    for j=1:x1
             if(I3(i,j,1)==1) 
                Y1(i,1)= Y1(i,1)+1 ;
            end  
     end       
 end
Py1=1;
Py0=1;
while ((Y1(Py0,1)<30)&&(Py0<y1))
      Py0=Py0+1;
end
Py1=Py0;
 while((Y1(Py1,1)>=30)&&(Py1<y1))
         Py1=Py1+1;
 end
d=d(Py0:Py1,:,:);
figure(9),subplot(2,2,4);
imshow(d),title('4.目标车牌区域');
%%   在列方向上进行灰度值累加
X1=zeros(1,x1);
for j=1:x1
    for i=1:y1
             if(I3(i,j,1)==1) 
                X1(1,j)= X1(1,j)+1;
            end  
     end       
end
figure(10);
plot(0:x1-1,X1),title('列方向像素点灰度值累计和'),xlabel('列值'),ylabel('累计像素量');
close all;

Px0=1;
Px1=1;
%%   分割字符
for i=1:7
  while ((X1(1,Px0)<2)&&(Px0<x1))
      Px0=Px0+1;
  end
  Px1=Px0;
  while (((X1(1,Px1)>=3)&&(Px1<x1))||((Px1-Px0)<10))
      Px1=Px1+1;
  end
  Z=d(:,Px0:Px1,:);
  switch strcat('Z',num2str(i))        %拼接Z1~Z7
      case 'Z1'
          PIN0=Z;
      case 'Z2'
          PIN1=Z;
      case 'Z3'
          PIN2=Z;
      case 'Z4'
          PIN3=Z;
      case 'Z5'
          PIN4=Z;
      case 'Z6'
          PIN5=Z;
      otherwise 
          PIN6=Z;
  end
  figure(11);
  subplot(1,7,i);
  imshow(Z);
  Px0=Px1;
end
%%   载入训练好的神经网络
load('-mat','ym');
%%  将分割后的车牌字符归一化处理

for ii=1:7   
    switch ii
      case 1
          PIN0=pretreatment(PIN0);
          Z2=A;
          imwrite(Z2,'A.jpg');
      case 2
         PIN1=pretreatment(PIN1);
         Z2=A;
      case 3
          PIN2=pretreatment(PIN2);
          Z2=A;
      case 4
          PIN3=pretreatment(PIN3);
          Z2=A;
      case 5
          PIN4=pretreatment(PIN4);
          Z2=A;
      case 6
          PIN5=pretreatment(PIN5);
          Z2=A;
      otherwise 
          PIN6=pretreatment(PIN6);
          Z2=A;
    end
    
     figure(12);
  subplot(1,7,ii);
  imshow(Z2);   
end

P0=[PIN0',PIN1',PIN2',PIN3',PIN4',PIN5',PIN6'];







%%  开始识别字符
for i=2:7     %循环六次识别六个车牌字母
  T0= sim(net ,P0(:,i));
  T1 = compet (T0) ;
  d =find(T1 == 1)-1
 if (d==0)
    str='A';
 elseif (d==1)
     str='B';
 elseif (d==2)
     str='C';
 elseif (d==3)
     str='D';
 elseif (d==4)
     str='E';
 elseif (d==5)
     str='F';
 elseif (d==6)
     str='G';
 elseif (d==7)
     str='H';
 elseif (d==8)
     str='I';
 elseif (d==9)
     str='J';
 elseif (d==10)
     str='K';
 elseif (d==11)
     str='L';
 elseif (d==12)
     str='M';
 elseif (d==13)
     str='N';
 elseif (d==14)
     str='O';
 elseif (d==15)
     str='P';
 elseif (d==16)
     str='Q';
 elseif (d==17)
     str='R';
 elseif (d==18)
     str='S';
 elseif (d==19)
     str='T';
 elseif (d==20)
     str='U';
 elseif (d==21)
     str='V';
 elseif (d==22)
     str='W';
 elseif (d==23)
     str='X';
 elseif (d==24)
     str='Y';
 elseif (d==25)
     str='Z';
 else
    str=num2str(d);
 end
 switch i       %代表车牌位置
     case 2
         str1=str;
     case 3
         str2=str;
     case 4
         str3=str;
     case 5
         str4=str;
     case 6
         str5=str;
     otherwise
         str6=str;
  end
end 
s=strcat('京',str1,'.',str2,str3,str4,str5,str6); 
figure(13);
imshow('dw.jpg'),title(s);


