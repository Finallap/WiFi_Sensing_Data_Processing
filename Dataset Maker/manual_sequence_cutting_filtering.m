%clear;
load('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ���ң���ֵ��λ��ϣ�.mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    amplitude = csi_train{i,1}';%�����н���ת��
    %amplitude = wifi_butterworth_function(amplitude);%�����˲�
    csi_train{i,1}=amplitude;%д������
end

csi_label = categorical(csi_label(:,1));