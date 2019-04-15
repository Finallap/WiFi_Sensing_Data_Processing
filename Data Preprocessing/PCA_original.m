amplitude=amplitudeA;
[r,c]=size(amplitude);%获取矩阵的行数和列数
me=mean(amplitude);%mean(A)将其中的各列视为向量
m=repmat(me,[r,1]);%以me的内容堆叠在（rx1）的矩阵m中
B=amplitude-m;%每个数减去平均值
C=cov(B);%若Ｘ大小为M*N，则cov(X)大小为N*N的矩阵。cov(X)的第(i,j)个元素等于X的第i列向量与第j列向量的方差，即C(Xi,Xj)
[ev,ed]=eig(C);%求矩阵A的全部特征值，构成对角阵ed，并求A的特征向量构成ev的列向量。

M=ev(:,30);
out=amplitude*M;
fangcha=var(out);
plot(out,'r');
tt1 = out(60:170,:);
tt2 = out(360:430,:);
hold on

M=ev(:,29);
out=amplitude*M;
out=diff(out);
plot(out,'b')
fangcha1=var(out);

 M=ev(:,28);
 out1=amplitude*M;
 fangcha2=var(out1);
 plot(out1,'g')
% 
% M=ev(:,27);
% out=amplitudeB*M;
% plot(out,'y')
% %legend('first','second','third','fourth')
legend('first','second','third')
title('PCA')
hold off