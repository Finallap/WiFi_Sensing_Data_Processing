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
    amplitude=wifi_butterworth(amplitude);
    
    %����PCA�˲�������������
    pca_sequence = wifi_pca(amplitude);
    
    %д��ѵ�����ͱ�ǩ
    csi_train{end+1,1} = pca_sequence;
    csi_label{end+1,1} = label;
end

function fileNames = traversing_folder(dirPath,fileExtension)
fileFolder=fullfile(dirPath);
dirOutput=dir(fullfile(fileFolder,fileExtension));
fileNames={dirOutput.name};
end

function amplitude = csi_amplitude_reading(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    amplitude=zeros(180,L);

    for m=1:L
        csi_entry=csi_trace{m};
        csi=get_scaled_csi(csi_entry);

        csi1=abs(squeeze(csi));       %amplitude
        tmp=csi1(1,1,:);
        amplitude(1:30,m)=tmp(1:30);
        tmp=csi1(1,2,:);
        amplitude(31:60,m)=tmp(1:30);
        tmp=csi1(1,3,:);
        amplitude(61:90,m)=tmp(1:30);
        tmp=csi1(2,1,:);
        amplitude(91:120,m)=tmp(1:30);
        tmp=csi1(2,2,:);
        amplitude(121:150,m)=tmp(1:30);
        tmp=csi1(2,3,:);
        amplitude(151:180,m)=tmp(1:30);
    end
end

function sequence=wifi_butterworth(sequence)
    sequence = sequence';
    fs=100;%����Ƶ��
    wp=5;         %ͨ����ֹƵ��
    ws=8;         %�����ֹƵ��
    rp=1;               %ͨ�����˥��
    as=60;              %�����С˥��
    wp=2*wp/fs;         %��ͨ����ֹƵ��
    ws=2*ws/fs;         %�������ֹƵ��
    [N,wc]=buttord(wp,ws,rp,as);    %wp��ͨ����ֹƵ�ʣ�ws�������ֹƵ�ʡ���Ҫ���Բ����ʵ�һ����й�һ��������Ϊ��0-1�� rp��as��ͨ���������˥��
    [B,A]=butter(N,wc);         %n���˲����Ľ�����wc�ǽ�ֹƵ�ʣ�wc = ��ֹƵ��*2/����Ƶ��
    [H,W]=freqz(B,A);       %[H��W] = freqz��b��a��n������n�㸴Ƶ��Ӧʸ��H��n���Ƶ������w��b��aΪϵͳ���ݺ����ķ��Ӻͷ�ĸ��ϵ�����������nû��ָ����Ĭ��Ϊ512��
    for i=1:180
        m_aB = mean(sequence(:,i));
        x = sequence(:,i)-m_aB;
        sequence(:,i) = filter(B,A,x)+m_aB;        %����xΪ�˲�ǰ���У�������˲�������У�B/A �ṩ�˲���ϵ����BΪ���ӣ�AΪ��ĸ 
    end
    sequence = sequence';
end

function pca_sequence=wifi_pca(amplitude)
    L=length(amplitude);
    pca_sequence=zeros(12,L);
    for steam_start_nums = 1:30:180
        [coeff,score] = pca(amplitude(steam_start_nums : steam_start_nums+29 , :)');
        pca_num = (steam_start_nums-1)/30 + 1;
        pca_sequence(pca_num,:) = score(:,1)';%�����һ���ɷ�
        pca_sequence(pca_num + 6 ,:)  = score(:,2)';%����ڶ����ɷ�
    end
end