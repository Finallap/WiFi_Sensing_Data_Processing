%先载入数据，制作sequence_label标签数组
rssi = rssi_reading('G:\无源感知研究\数据采集\2019_07_18\实验室\clap_chen_2.dat')';
%amplitude = csi_amplitude_reading('G:\无源感知研究\数据采集\2019_07_18\实验室\clap_chen_2.dat')';
%phase = csi_phase_reading('G:\无源感知研究\数据采集\2019_07_18\实验室\pull_chen_2.dat')';

if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end
label_name = 'pull';%标签名字
person_label_name = 'chen';

%sequence_label第一列为起点，第二列为终点
for i=1:length(sequence_label)
    start = sequence_label(i,1);
    the_end = sequence_label(i,2);
    selection_rssi_sequence = rssi(start:the_end,:);%选取幅值
    %selection_amplitude_sequence = amplitude(start:the_end,:);%选取幅值
    %selection_phase_sequence = phase(start:the_end,:);%选取相位
    %selection_phase_sequence = unwrap(selection_phase_sequence);%相位解缠
    
    csi_label_size = size(csi_label);
    csi_label_length = csi_label_size(1);
    
    csi_train{end+1,1} = selection_rssi_sequence;%添加rssi信息
    %csi_train{end+1,1} = selection_amplitude_sequence;%添加幅值信息
    %csi_train{end+1,1} = selection_phase_sequence;%添加相位信息
    csi_label{csi_label_length + 1,1} = label_name;
    csi_label{csi_label_length + 1,2} = person_label_name;
end