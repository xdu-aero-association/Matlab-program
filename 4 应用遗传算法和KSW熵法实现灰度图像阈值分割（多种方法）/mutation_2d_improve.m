function [v10,v11]=mutation_2d_improve(c10,c11,k)
    
    %±äÒìËã×Ó
    
    format long;
    
    population=20;
    
    pm=0.21875000-0.00007875*(k-50)^2;
    
    for i=1:population
        for j=1:8
            r0=rand(1);
            r1=rand(1);
            if r0>pm
                temp0(i,j)=c10(i,j);
            else
                tt=not(str2num(c10(i,j)));
                temp0(i,j)=num2str(tt);
            end
            if r1>pm
                temp1(i,j)=c11(i,j);
            else
                tt=not(str2num(c11(i,j)));
                temp1(i,j)=num2str(tt);
            end
        end
    end
    
    v10=temp0;
    v11=temp1;
    
    