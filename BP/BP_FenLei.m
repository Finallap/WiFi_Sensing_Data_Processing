%��ȡѵ���ص����ݡ��������
num1=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',4);
num2=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',5);

%����ֵ��һ��,premnmx���ڹ�һ������ѵ�����ݼ�
[xunlian_input,minI,maxI] = premnmx(num1);
[xunlian_output,minP,maxP] = premnmx(num2);

%����������
%��newff��������ǰ����BP���磬�趨��������Ԫ��ĿΪ10
% �ֱ�ѡ������Ĵ��ݺ���Ϊlogsig������S��ת�ƺ������������Ĵ��ݺ���Ϊ purelin
% ѧϰ�㷨Ϊ�ݶ��½���traingd
net1 = newff(minmax(xunlian_input),[10,10,10,10,10,6],{'logsig','logsig','logsig','logsig','logsig','purelin'} ,'traingd'); 

%����ѵ������
net1.trainparam.show = 50 ;  %��ʾ�м���������
net1.trainparam.epochs =100000;  %����������
net1.trainparam.goal = 1e-4 ;  %������ѵ����Ŀ�����
net1.trainParam.lr = 0.01 ;  %ѧϰ��

%��ʼѵ��
[net1,tr,YI,E] = train(net1,xunlian_input,xunlian_output);  %YI,����ʵ�������E,������

%��ȡ����������
%feilei_Input=Y;
num3=xlsread('C:\Users\lenovo\Desktop\2019_04_28_data\sample-2-feature',6);
[Input,minp,maxp] = premnmx(num3);

%����
%W = sim(net1 ,feilei_Input);
Y = sim(net1 ,Input); 

%ͳ��ʶ����ȷ��