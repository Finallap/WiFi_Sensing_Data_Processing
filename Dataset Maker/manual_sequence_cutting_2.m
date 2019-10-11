%���������ݣ�����sequence_label��ǩ����
if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end

fir_path = 'G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����\';

%sequence_label��һ��Ϊ��㣬�ڶ���Ϊ�յ�
for i=1:length(sequence_label)
    label_name = sequence_label{i,2};%��ǩ����
    person_label_name = sequence_label{i,1};%��������
    file_time = sequence_label{i,3};%�ļ�����
    
    datapath = sprintf('%s%s_%s_%d%s',fir_path,label_name,person_label_name,file_time,'.dat');
    disp(datapath)
    amplitude = csi_amplitude_reading(datapath)';
    phase = csi_phase_reading(datapath)';
    
    start = sequence_label{i,4};
    the_end = sequence_label{i,5};
    selection_amplitude_sequence = amplitude(start:the_end,:);%ѡȡ��ֵ
    selection_phase_sequence = phase(start:the_end,:);%ѡȡ��λ
    selection_phase_sequence = unwrap(selection_phase_sequence);%��λ���
    selection_sequence = [selection_amplitude_sequence selection_phase_sequence];
    
    csi_label_size = size(csi_label);
    csi_label_length = csi_label_size(1);
    
    csi_train{end+1,1} = selection_sequence;
    csi_label{csi_label_length + 1,1} = label_name;
    csi_label{csi_label_length + 1,2} = person_label_name;
end