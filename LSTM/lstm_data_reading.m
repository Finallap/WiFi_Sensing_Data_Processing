%clear;
if(exist('csi_train','var')==0)
    csi_train = {};
    csi_label = {};
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
    
    %进行PCA滤波，并构建序列
    pca_sequence = wifi_pca(amplitude);
    
    %写入训练集和标签
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
    fs=100;%采样频率
    wp=5;         %通带截止频率
    ws=8;         %阻带截止频率
    rp=1;               %通带最大衰减
    as=60;              %阻带最小衰减
    wp=2*wp/fs;         %求通带截止频率
    ws=2*ws/fs;         %求阻带截止频率
    [N,wc]=buttord(wp,ws,rp,as);    %wp是通带截止频率，ws是阻带截止频率。需要除以采样率的一半进行归一化，即变为（0-1） rp和as是通带和阻带的衰减
    [B,A]=butter(N,wc);         %n是滤波器的阶数，wc是截止频率，wc = 截止频率*2/采样频率
    [H,W]=freqz(B,A);       %[H，W] = freqz（b，a，n）返回n点复频响应矢量H和n点的频率向量w。b和a为系统传递函数的分子和分母的系数向量。如果n没有指定，默认为512。
    for i=1:180
        m_aB = mean(sequence(:,i));
        x = sequence(:,i)-m_aB;
        sequence(:,i) = filter(B,A,x)+m_aB;        %输入x为滤波前序列，左边是滤波结果序列，B/A 提供滤波器系数，B为分子，A为分母 
    end
    sequence = sequence';
end

function pca_sequence=wifi_pca(amplitude)
    L=length(amplitude);
    pca_sequence=zeros(12,L);
    for steam_start_nums = 1:30:180
        [coeff,score] = pca(amplitude(steam_start_nums : steam_start_nums+29 , :)');
        pca_num = (steam_start_nums-1)/30 + 1;
        pca_sequence(pca_num,:) = score(:,1)';%放入第一主成分
        pca_sequence(pca_num + 6 ,:)  = score(:,2)';%放入第二主成分
    end
end