%%  学习目标：图像处理实现人脸识别
%获取RGB图片
i=imread('face.jpg');
I=rgb2gray(i);
BW=im2bw(I);
figure(1)
imshow(BW)
%最小化背景
[n1 n2]=size(BW);
r=floor(n1/10);
c=floor(n2/10);
x1=1;x2=r;
s=r*c;

for i=1:10
    y1=1;y2=c;
    for j=1:10
        if (y2<=c | y2>=9*c) | (x1==1 | x2==r*10)
            loc=find(BW(x1:x2, y1:y2)==0);
            [o p]=size(loc);
            pr=o*100/s;
            if pr<=100
                BW(x1:x2, y1:y2)=0;
                r1=x1;r2=x2;s1=y1;s2=y2;
                pr1=0;
            end
            imshow(BW);
        end
            y1=y1+c;
            y2=y2+c;
    end
    
 x1=x1+r;
 x2=x2+r;
end
figure(2)
subplot(1,2,1);
imshow(BW)
title('图像处理')
%人脸识别
L = bwlabel(BW,8);
BB  = regionprops(L, 'BoundingBox');
BB1=struct2cell(BB);
BB2=cell2mat(BB1);

[s1 s2]=size(BB2);
mx=0;
for k=3:4:s2-1
    p=BB2(1,k)*BB2(1,k+1);
    if p>mx & (BB2(1,k)/BB2(1,k+1))<1.8
        mx=p;
        j=k;
    end
end
subplot(1,2,2);
title('人脸识别')
imshow(I);
hold on;
rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' )
%%   大仙QQ：1960009019
%%   在线教育微信公众号：大仙一品堂 
