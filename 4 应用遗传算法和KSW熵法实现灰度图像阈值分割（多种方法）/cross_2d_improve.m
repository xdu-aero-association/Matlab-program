function [c10,c11]=cross_2d_improve(s_code10,s_code11,k)
   
   %交叉算子
  
   if k <= 50                                 %交叉概率取0.8,0.6
       pc=0.8; 
   else
       pc=0.6; 
   end
   
   
   population=20;
   
   %(1,2)/(3,4)/(5,6)进行交叉运算，(7,8)/(9,10)复制
   
   ww0=s_code10;
   ww1=s_code11;
   
   for i=1:(pc*population/2)
       r0=abs(round(rand(1)*10)-3);
       r1=abs(round(rand(1)*10)-3);
       for j=(r0+1):8
           temp0=ww0(2*i-1,j);
           ww0(2*i-1,j)=ww0(2*i,j);
           ww0(2*i,j)=temp0; 
       end
       for j=(r1+1):8
           temp1=ww1(2*i-1,j);
           ww1(2*i-1,j)=ww1(2*i,j);
           ww1(2*i,j)=temp1; 
       end
   end
   
   c10=ww0;
   c11=ww1;
   
   
           
           
       
       
   
   
   
   