clear;
load('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����(3t3r)(1).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    amplitude = csi_train{i,1}';%�����н���ת��
    amplitude = hampel(amplitude);%hampel�˲�
    amplitude = wifi_butterworth_function(amplitude);%�����˲�
    %[amplitude,PS]=mapminmax(amplitude);%��һ������
    amplitude = normalize(amplitude);
    csi_train{i,1}=amplitude;%д������
end

csi_label = categorical(csi_label(:,1));