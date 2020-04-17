function s1=select_2d(X1,adapt_value1)
    
    %Ñ¡ÔñËã×Ó
    
    population=20;
    
    total_adapt_value1=0;
    for i=1:population
        total_adapt_value1=total_adapt_value1+adapt_value1(i);
    end
    adapt_value1_new=adapt_value1/total_adapt_value1;
        
    r=rand(1,population);
    
    for i=1:population
        temp=0;
        for j=1:population
            temp=temp+adapt_value1_new(j);
            if temp>=r(i)
                s1(i,:)=X1(j,:);
                break;
            end
        end
    end
    
    
            
            
            
            
        
        
        
