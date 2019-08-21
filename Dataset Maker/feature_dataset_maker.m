%clear;
if(exist('data_array','var')==0)
    data_array = [];
end

label = 'CounterclockwiseRound';%��ǩ����
dirPath = 'G:\��Դ��֪�о�\���ݲɼ�\2019_04_28_copy\6';
fileNums = 19;
fileNames = traversing_folder(dirPath,'*.dat');

%ѭ�����������ļ��У���д�����ݼ�
for i=1:fileNums
    %��ȡCSI��ֵ���������˲�
    amplitude = csi_amplitude_reading(strcat(dirPath,'\',fileNames{1,i}));
    amplitude=wifi_butterworth(amplitude);
    
    for k=1:180
        mean(pca_sequence(k,:));
    end
    
    %д��ѵ�����ͱ�ǩ
    data_array{end+1,:} = pca_sequence;
    data_array(end+1,1) = label;
end

%�ǵ���������д���ˣ��ѱ�ǩת����categorical
%csi_label = categorical(csi_label);