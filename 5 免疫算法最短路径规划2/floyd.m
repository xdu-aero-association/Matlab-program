%%%%%%%%%%%%%floyd函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%floyd算法直接在图的带权邻接矩阵中用插入顶点的方法依次递推地
%构造出n个矩阵D(1), D(2), …, D(n),
%D(n)是图的距离矩阵, 同时引入一个后继点矩阵记录两点间的最短路径.
function [D,path,min1,path1]=floyd(a,start,terminal)
D=a;n=size(D,1);path=zeros(n,n);
for i=1:n
   for j=1:n
      if D(i,j)~=inf
         path(i,j)=j;
end,  end, end
for k=1:n
   for i=1:n
      for j=1:n
         if D(i,k)+D(k,j)<D(i,j)
            D(i,j)=D(i,k)+D(k,j);
            path(i,j)=path(i,k);
         end
      end
   end
end

if nargin==3
   min1=D(start,terminal);
   m(1)=start;
   i=1;
   path1=[ ];   
   while   path(m(i),terminal)~=terminal
      k=i+1;                                
      m(k)=path(m(i),terminal);
      i=i+1;
   end
   m(i+1)=terminal;
   path1=m;
end   
