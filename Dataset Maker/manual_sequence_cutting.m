%���������ݣ�����sequence_label��ǩ����
rssi = rssi_reading('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����\clap_chen_2.dat')';
%amplitude = csi_amplitude_reading('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����\clap_chen_2.dat')';
%phase = csi_phase_reading('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\ʵ����\pull_chen_2.dat')';

if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
end
label_name = 'pull';%��ǩ����
person_label_name = 'chen';

%sequence_label��һ��Ϊ��㣬�ڶ���Ϊ�յ�
for i=1:length(sequence_label)
    start = sequence_label(i,1);
    the_end = sequence_label(i,2);
    selection_rssi_sequence = rssi(start:the_end,:);%ѡȡ��ֵ
    %selection_amplitude_sequence = amplitude(start:the_end,:);%ѡȡ��ֵ
    %selection_phase_sequence = phase(start:the_end,:);%ѡȡ��λ
    %selection_phase_sequence = unwrap(selection_phase_sequence);%��λ���
    
    csi_label_size = size(csi_label);
    csi_label_length = csi_label_size(1);
    
    csi_train{end+1,1} = selection_rssi_sequence;%���rssi��Ϣ
    %csi_train{end+1,1} = selection_amplitude_sequence;%��ӷ�ֵ��Ϣ
    %csi_train{end+1,1} = selection_phase_sequence;%�����λ��Ϣ
    csi_label{csi_label_length + 1,1} = label_name;
    csi_label{csi_label_length + 1,2} = person_label_name;
end