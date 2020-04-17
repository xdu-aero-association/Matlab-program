function bp()
%use for bp training
I0=pretreatment(imread('A.jpg'));
I1=pretreatment(imread('B.jpg'));
I2=pretreatment(imread('C.jpg'));
I3=pretreatment(imread('D.jpg'));
I4=pretreatment(imread('E.jpg'));
I5=pretreatment(imread('F.jpg'));
I6=pretreatment(imread('G.jpg'));
I7=pretreatment(imread('H.jpg'));
I8=pretreatment(imread('I.jpg'));
I9=pretreatment(imread('J.jpg'));
I10=pretreatment(imread('K.jpg'));
I11=pretreatment(imread('L.jpg'));
I12=pretreatment(imread('M.jpg'));
I13=pretreatment(imread('N.jpg'));
I14=pretreatment(imread('O.jpg'));
I15=pretreatment(imread('P.jpg'));
I16=pretreatment(imread('Q.jpg'));
I17=pretreatment(imread('R.jpg'));
I18=pretreatment(imread('S.jpg'));
I19=pretreatment(imread('T.jpg'));
I20=pretreatment(imread('U.jpg'));
I21=pretreatment(imread('V.jpg'));
I22=pretreatment(imread('W.jpg'));
I23=pretreatment(imread('X.jpg'));
I24=pretreatment(imread('Y.jpg'));
I25=pretreatment(imread('Z.jpg'));
P=[I0',I1',I2',I3',I4',I5',I6',I7',I8',I9',I10',I11',I12',I13',I14',I15',I16',I17',I18',I19',I20',I21',I22',I23',I24',I25'];
%输出样本%
T=eye(26,26);
%%bp神经网络参数设置
net=newff(minmax(P),[800,23,26],{'logsig','logsig','logsig'},'trainrp');
net.inputWeights{1,1}.initFcn ='randnr';
net.layerWeights{2,1}.initFcn ='randnr';
net.trainparam.epochs=5000;
net.trainparam.show=50;
net.trainparam.goal=0.0000000001;
net=init(net);
%%%训练样本%%%%
[net,tr]=train(net,P,T);
save('ym','net');