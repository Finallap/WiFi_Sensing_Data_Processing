clear;
load('G:\无源感知研究\数据采集\2019_07_18\实验室(3t3r)(1).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    amplitude = csi_train{i};
    sequenceLengths(i) = size(amplitude,1);
end

for i=1:sample_num
    amplitude = csi_train{i,1}';%对序列进行转置
    amplitude = hampel(amplitude);%hampel滤波
    amplitude = wifi_butterworth_function(amplitude);%butterworth滤波
    amplitude = resample(amplitude',ceil(mean(sequenceLengths)),size(amplitude,2));
    amplitude = amplitude';
    %[amplitude,PS]=mapminmax(amplitude);
    amplitude = normalize(amplitude);%归一化处理
    csi_train{i,1}=amplitude;%写回序列
end

csi_label = categorical(csi_label(:,1));
clear sample_num i amplitude