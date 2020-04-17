function v1=mutation_ga(c1)
    
    %±äÒìËã×Ó
    
    format long;
    
    population=10;
    
    pm=0.02;
    
    for i=1:population
        for j=1:8
            r=rand(1);
            if r>pm
                temp(i,j)=c1(i,j);
            else
                tt=not(str2num(c1(i,j)));
                temp(i,j)=num2str(tt);
            end
        end
    end
    
    v1=temp;
    
    