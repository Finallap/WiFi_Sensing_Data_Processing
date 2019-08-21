%clear;
if(exist('data_array','var')==0)
    data_array = [];
end

label = 'CounterclockwiseRound';%标签名字
dirPath = 'G:\无源感知研究\数据采集\2019_04_28_copy\6';
fileNums = 19;
fileNames = traversing_folder(dirPath,'*.dat');

%循环遍历整个文件夹，并写入数据集
for i=1:fileNums
    %读取CSI幅值，并进行滤波
    amplitude = csi_amplitude_reading(strcat(dirPath,'\',fileNames{1,i}));
    amplitude=wifi_butterworth(amplitude);
    
    for k=1:180
        mean(pca_sequence(k,:));
    end
    
    %写入训练集和标签
    data_array{end+1,:} = pca_sequence;
    data_array(end+1,1) = label;
end

%记得所有数据写完了，把标签转换成categorical
%csi_label = categorical(csi_label);