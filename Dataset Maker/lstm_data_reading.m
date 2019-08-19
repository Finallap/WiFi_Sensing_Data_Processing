%clear;
if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end

label = 'CounterclockwiseRound';%��ǩ����
dirPath = 'G:\��Դ��֪�о�\���ݲɼ�\2019_04_28_copy\6';
fileNums = 19;
fileNames = traversing_folder(dirPath,'*.dat');

%ѭ�����������ļ��У���д�����ݼ�
for i=1:fileNums
    %��ȡCSI��ֵ���������˲�
    amplitude = csi_amplitude_reading(strcat(dirPath,'\',fileNames{1,i}));
    amplitude=wifi_butterworth_function(amplitude);
    
    %����PCA�˲�������������
    pca_sequence = wifi_pca(amplitude);
    
    %д��ѵ�����ͱ�ǩ
    csi_train{end+1,1} = pca_sequence;
    csi_label{end+1,1} = label;
end

%�ǵ���������д���ˣ��ѱ�ǩת����categorical
%csi_label = categorical(csi_label);