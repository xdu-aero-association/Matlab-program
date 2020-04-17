function s1=select_ga_improve(X1,adapt_value1)
    
    %Ñ¡ÔñËã×Ó
    
    population=10;
    
    total_adapt_value1=0;
    for i=1:population
        total_adapt_value1=total_adapt_value1+adapt_value1(i);
    end
    adapt_value1_new=adapt_value1/total_adapt_value1;
    
    max_adapt_value1=max(adapt_value1);                               % 10%¾«Ó¢²ßÂÔ
    s1(1)=round(mean(X1(find(adapt_value1==max_adapt_value1))));
        
    r=rand(1,population-1);
    
    for i=2:population                                                % 90%ÂÖÅÌ¶Ä·¨
        temp=0;
        for j=1:population
            temp=temp+adapt_value1_new(j);
            if temp>=r(i-1)
                s1(i)=X1(j);
                break;
            end
        end
    end
    
    
            
            
            
            
        
        
        
