clear;
load('G:\无源感知研究\数据采集\2019_07_18\会议室(3t3r)(1).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    csi_train1{i, 1} = csi_train{i, 1}(:,181:270);%对序列进行转置
end
clear csi_train sample_num i
csi_train = csi_train1;
clear csi_train1
save('G:\无源感知研究\数据采集\2019_07_18\改变天线数据\会议室(3t3r)(1)_t3')