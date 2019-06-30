%读取训练、部署数据
num1=xlsread('C:\Users\lenovo\Desktop\input');
num2=xlsread('C:\Users\lenovo\Desktop\output');

%特征值归一化,premnmx用于归一化处理训练数据集
[input,minI,maxI,output,mint,maxt] = premnmx(num1,num2);

%创建神经网络
%用newff函数生成前向型BP网络，设定隐层中神经元数目为7
% 分别选择隐层的传递函数为logsig（对数S形转移函数），输出层的传递函数为 purelin
% 学习算法为梯度下降法traingd
net = newff(minmax(input),[7,7,7,7,7,3],{'logsig','logsig','logsig','logsig','logsig','purelin'} ,'traingd'); 

%设置训练参数
net.trainparam.show = 50 ;  %显示中间结果的周期
net.trainparam.epochs =5000 ;  %最大迭代次数
net.trainparam.goal = 1e-6 ;  %神经网络训练的目标误差
net.trainParam.lr = 0.01 ;  %学习率

%开始训练
[net,tr,y,E] = train(net,input,output);

%读取测试数据
num3=xlsread('C:\Users\lenovo\Desktop\ceshi');

%测试数据归一化,tramnmx用于归一化处理待分类的输入数据
%testInput =tramnmx(Input,minp,maxp);
[Input,minp,maxp] = premnmx(num3);

%仿真
Y = sim(net ,Input);

%统计识别正确率
