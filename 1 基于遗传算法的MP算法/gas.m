function [proj,scale,translation,freq,phase]=gas(signal_r,N,a_base,j_min,j_max,u_base,p_min,v_base,k_min,w_base,i_min,i_max);



n=21;
Ngen=50;

pool=zeros(4,n);
sig=[1
   1 
   1 
   1];

proj_trans=zeros(1,n);
res=ones(1,n);

proj=0;


bi=ones(4,1);
bs=ones(4,1);

% bi: lower bounds
% bs: upper bounds

bi(1)=j_min;
bi(2)=p_min;
bi(3)=k_min;
bi(4)=i_min;

bs(1)=j_max;
bs(2)=N;
bs(3)=N;
bs(4)=i_max;

% og(i,:) : vector of n i-genes
% ng: new generation vector

og=ones(4,n);
ng=ones(4,n);

% create the initial population

og(1,:)=round((bs(1)-bi(1))*rand(1,n)+bi(1));
og(2,:)=round((bs(2)-bi(2))*rand(1,n)+bi(2));
og(3,:)=round((bs(3)-bi(3))*rand(1,n)+bi(3));
og(4,:)=round((bs(4)-bi(4))*rand(1,n)+bi(4));

% the main part of  Genetic algorithm
%og(:,1:10)
%og(:,11:21)


for c=1:Ngen

        for d=1:n
              
           
            s=a_base^og(1,d);
            u=og(2,d);
            v=og(3,d)*(1/s)*v_base;
            w=og(4,d)*w_base;
            t=0:N-1;
            t=(t-u)/s;
            
            g=(1/sqrt(s))*exp(-pi*t.*t).*cos(v*t+w);
            
            g=g/sqrt(sum(g.*g));
            
            proj_trans(d)=sum(signal_r.*g);
            
            res(d)=abs(proj_trans(d));
            
         end
         
         % place the best atom (biggest projection in the first  position
         
         [best, e]=max(res);
         
         ng(:,1)=og(:,e);
         
         og(:,e)=og(:,n);
         
         og(:,n)=ng(:,1);
         
         temp_proj=proj_trans(e);
         temp_res=res(e);
         
         proj_trans(e)=proj_trans(n);
         proj_trans(n)=temp_proj;
         
         res(e)=res(n);
         res(n)=temp_res;
         
         % competition between the adjacent atoms
         
         for d=2:2:n-1
            [best,e]=max(res(d-1:d));
            pool(:,d/2)=og(:,d-rem(e,2));
         end;
         
         % creation of the pool for crossover
         
         for d=1:(n-1)/2
            f=ceil((n-1)/2*rand);
            Inter=round(rand(4,1));
            ng(:,d+1)=pool(:,d).*Inter+pool(:,f).*(1-Inter);
         end
         
         % Mutations of the winner
         
         sigm=sig(:,ones(n-((n-1)/2+1),1));
         ngm=ng(:,1);
         ngm=ngm(:,ones(n-((n-1)/2+1),1));
         ng(:,(n-1)/2+2:n)=round(ngm+(rand(4,n-((n-1)/2+1))-0.5).*sigm);
         
         % bounding into the limits
         
         for l=1:4
            while max(ng(l,:))>bs(l)
               [rw,lw]=max(ng(l,:));
               ng(l,lw)=bs(l);
            end
            while min(ng(l,:))<bi(l)
               [rw,lw]=min(ng(l,:));
               ng(l,lw)=bi(l);
            end
         end
         
         og=ng;
         
         % stable or not?
         
         nog=og(:,1);
         nog=nog(:,ones(1,n));
         nog=abs(og-nog);
         
         nog=max(max(nog));
         
         % if yes, create a new generation
         
         if nog<4
            
            og(1,2:n)=round((bs(1)-bi(1))*rand(1,n-1)+bi(1));
            og(2,2:n)=round((bs(2)-bi(2))*rand(1,n-1)+bi(2));
            og(3,2:n)=round((bs(3)-bi(3))*rand(1,n-1)+bi(3));
            og(4,2:n)=round((bs(4)-bi(4))*rand(1,n-1)+bi(4));
            
         end
      end
      
      
      
      
      % output the results
      
            s=a_base^ng(1,1);
            u=ng(2,1);
            v=ng(3,1)*(1/s)*v_base;
            w=ng(4,1)*w_base;
            t=0:N-1;
            t=(t-u)/s;
            
            g=(1/sqrt(s))*exp(-pi*t.*t).*cos(v*t+w);
            
            g=g/sqrt(sum(g.*g));
            
            proj=sum(signal_r.*g);
            
               scale=a_base^ng(1,1);
               translation=ng(2,1);
               freq=v;
               phase=w;
