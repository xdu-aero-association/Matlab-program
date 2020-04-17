function y=ksw_2d(s,t,mingrayvalue,maxgrayvalue,hist_2d_1,Hst)
   
    %计算二维最佳直方图熵（KSW熵）
    
    W0=0;
    for i=0:s
        for j=0:t
            W0=W0+hist_2d_1(i+1,j+1);
        end
    end
    
    
    H0=0;
    for i=0:s
        for j=0:t
            if hist_2d_1(i+1,j+1)==0
                temp=0;
            else
                temp=hist_2d_1(i+1,j+1)*log(1/hist_2d_1(i+1,j+1));
            end
            H0=H0+temp;
        end
    end
        
    
    
    
    if W0==0 | W0==1           %   or(Pt==0,Pt==1)
        temp1=0;
    else 
        temp1=log(W0*(1-W0))+H0/W0+(Hst-H0)/(1-W0);
    end
    
    if temp1 < 0
        H=0;
    else
        H=temp1;
    end
        
    
    y=H;

