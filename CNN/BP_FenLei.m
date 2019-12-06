%读取训练地点数据、类别数据
num1=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',4);
num2=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',5);

%特征值归一化,premnmx用于归一化处理训练数据集
[xunlian_input,minI,maxI] = premnmx(num1);
[xunlian_output,minP,maxP] = premnmx(num2);

%创建神经网络
%用newff函数生成前向型BP网络，设定隐层中神经元数目为10
% 分别选择隐层的传递函数为logsig（对数S形转移函数），输出层的传递函数为 purelin
% 学习算法为梯度下降法traingd
net1 = newff(minmax(xunlian_input),[10,10,10,10,10,6],{'logsig','logsig','logsig','logsig','logsig','purelin'} ,'traingd'); 

%设置训练参数
net1.trainparam.show = 50 ;  %显示中间结果的周期
net1.trainparam.epochs =100000;  %最大迭代次数
net1.trainparam.goal = 1e-4 ;  %神经网络训练的目标误差
net1.trainParam.lr = 0.01 ;  %学习率

%开始训练
[net1,tr,YI,E] = train(net1,xunlian_input,xunlian_output);  %YI,网络实际输出；E,误差矩阵

%读取待分类数据
%feilei_Input=Y;
num3=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',6);
[Input,minp,maxp] = premnmx(num3);

%仿真
%W = sim(net1 ,feilei_Input);
Y = sim(net1 ,Input); 

%统计识别正确率