%���������ݣ�����sequence_label��ǩ����
csi_train = cell(length(sequence_label),1);
csi_label = cell(length(sequence_label),2);
fir_path = 'G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\������\';

%sequence_label��һ��Ϊ��㣬�ڶ���Ϊ�յ�
for i=1:length(sequence_label)
    label_name = sequence_label{i,2};%��ǩ����
    person_label_name = sequence_label{i,1};%��������
    file_time = sequence_label{i,3};%�ļ�����
    
    datapath = sprintf('%s%s_%s_%d%s',fir_path,label_name,person_label_name,file_time,'.dat');
    disp(datapath)
    amplitude = csi_amplitude_reading_and_interpolation(datapath)';
    %phase = csi_phase_reading(datapath)';
    
    start = sequence_label{i,4};
    the_end = sequence_label{i,5};
    selection_amplitude_sequence = amplitude(start:the_end,:);%ѡȡ��ֵ
    %selection_phase_sequence = phase(start:the_end,:);%ѡȡ��λ
    %selection_phase_sequence = unwrap(selection_phase_sequence);%��λ���
    %selection_sequence = [selection_amplitude_sequence selection_phase_sequence];
    
    csi_train{i,1} = selection_amplitude_sequence;
    csi_label{i,1} = label_name;
    csi_label{i,2} = person_label_name;
end