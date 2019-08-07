%先载入数据，制作sequence_label标签数组
amplitude = csi_amplitude_reading('G:\无源感知研究\数据采集\2019_07_18\实验室\clap_chen_2.dat')';

if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end
label_name = 'clap';%标签名字
person_label_name = 'chen';

%sequence_label第一列为起点，第二列为终点
for i=1:length(sequence_label)
    start = sequence_label(i,1);
    the_end = sequence_label(i,2);
    selection_sequence = amplitude(start:the_end,:);
    
    csi_label_size = size(csi_label);
    csi_label_length = csi_label_size(1);
    
    csi_train{end+1,1} = selection_sequence;
    csi_label{csi_label_length + 1,1} = label_name;
    csi_label{csi_label_length + 1,2} = person_label_name;
end