%��ȡѵ������������
num1=xlsread('C:\Users\lenovo\Desktop\input');
num2=xlsread('C:\Users\lenovo\Desktop\output');

%����ֵ��һ��,premnmx���ڹ�һ������ѵ�����ݼ�
[input,minI,maxI,output,mint,maxt] = premnmx(num1,num2);

%����������
%��newff��������ǰ����BP���磬�趨��������Ԫ��ĿΪ7
% �ֱ�ѡ������Ĵ��ݺ���Ϊlogsig������S��ת�ƺ������������Ĵ��ݺ���Ϊ purelin
% ѧϰ�㷨Ϊ�ݶ��½���traingd
net = newff(minmax(input),[7,7,7,7,7,3],{'logsig','logsig','logsig','logsig','logsig','purelin'} ,'traingd'); 

%����ѵ������
net.trainparam.show = 50 ;  %��ʾ�м���������
net.trainparam.epochs =5000 ;  %����������
net.trainparam.goal = 1e-6 ;  %������ѵ����Ŀ�����
net.trainParam.lr = 0.01 ;  %ѧϰ��

%��ʼѵ��
[net,tr,y,E] = train(net,input,output);

%��ȡ��������
num3=xlsread('C:\Users\lenovo\Desktop\ceshi');

%�������ݹ�һ��,tramnmx���ڹ�һ��������������������
%testInput =tramnmx(Input,minp,maxp);
[Input,minp,maxp] = premnmx(num3);

%����
Y = sim(net ,Input);

%ͳ��ʶ����ȷ��
