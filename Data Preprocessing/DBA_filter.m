clear;
%load('G:\��Դ��֪�о�\���ݲɼ�\Cross Scene(201911)\Scene1(lab).mat');
load('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����(3t3r).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
amplitude = csi_train{i};
sequenceLengths(i) = size(amplitude,1);
end

for i=1:sample_num
amplitude = csi_train{i,1};%�����н���ת��
amplitude = hampel(amplitude);%hampel�˲�
%amplitude = wifi_butterworth_function(amplitude);%butterworth�˲�
amplitude = resample(amplitude,512,size(amplitude,1));
csi_train1{i,1}=amplitude;%д������
end