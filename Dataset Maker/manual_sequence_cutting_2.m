%先载入数据，制作sequence_label标签数组
if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end

fir_path = 'G:\无源感知研究\数据采集\2019_07_18\实验室\';

%sequence_label第一列为起点，第二列为终点
for i=1:length(sequence_label)
    label_name = sequence_label{i,2};%标签名字
    person_label_name = sequence_label{i,1};%姓名名字
    file_time = sequence_label{i,3};%文件次数
    
    datapath = sprintf('%s%s_%s_%d%s',fir_path,label_name,person_label_name,file_time,'.dat');
    disp(datapath)
    amplitude = csi_amplitude_reading(datapath)';
    phase = csi_phase_reading(datapath)';
    
    start = sequence_label{i,4};
    the_end = sequence_label{i,5};
    selection_amplitude_sequence = amplitude(start:the_end,:);%选取幅值
    selection_phase_sequence = phase(start:the_end,:);%选取相位
    selection_phase_sequence = unwrap(selection_phase_sequence);%相位解缠
    selection_sequence = [selection_amplitude_sequence selection_phase_sequence];
    
    csi_label_size = size(csi_label);
    csi_label_length = csi_label_size(1);
    
    csi_train{end+1,1} = selection_sequence;
    csi_label{csi_label_length + 1,1} = label_name;
    csi_label{csi_label_length + 1,2} = person_label_name;
end