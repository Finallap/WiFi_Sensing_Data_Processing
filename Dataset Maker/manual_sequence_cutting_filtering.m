clear;
load('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����(3t3r)(1).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    amplitude = csi_train{i};
    sequenceLengths(i) = size(amplitude,1);
end

for i=1:sample_num
    amplitude = csi_train{i,1}';%�����н���ת��
    amplitude = hampel(amplitude);%hampel�˲�
    amplitude = wifi_butterworth_function(amplitude);%butterworth�˲�
    amplitude = resample(amplitude',ceil(mean(sequenceLengths)),size(amplitude,2));
    amplitude = amplitude';
    %[amplitude,PS]=mapminmax(amplitude);
    amplitude = normalize(amplitude);%��һ������
    csi_train{i,1}=amplitude;%д������
end

csi_label = categorical(csi_label(:,1));
clear sample_num i amplitude