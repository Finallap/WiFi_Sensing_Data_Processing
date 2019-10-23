function sequence=wifi_butterworth_function(sequence)
    sequence = sequence';
    fs=100;%采样频率
    wp=2;         %通带截止频率
    ws=10;         %阻带截止频率
    rp=1;               %通带最大衰减
    as=60;              %阻带最小衰减
    wp=2*wp/fs;         %求通带截止频率
    ws=2*ws/fs;         %求阻带截止频率
    [N,wc]=buttord(wp,ws,rp,as);    %wp是通带截止频率，ws是阻带截止频率。需要除以采样率的一半进行归一化，即变为（0-1） rp和as是通带和阻带的衰减
    [B,A]=butter(N,wc);         %n是滤波器的阶数，wc是截止频率，wc = 截止频率*2/采样频率
    %[H,W]=freqz(B,A);       %[H，W] = freqz（b，a，n）返回n点复频响应矢量H和n点的频率向量w。b和a为系统传递函数的分子和分母的系数向量。如果n没有指定，默认为512。
    sequence_size = size(sequence);
    for i=1:sequence_size(2)
        m_aB = mean(sequence(:,i));
        x = sequence(:,i)-m_aB;
        sequence(:,i) = filter(B,A,x)+m_aB;        %输入x为滤波前序列，左边是滤波结果序列，B/A 提供滤波器系数，B为分子，A为分母 
    end
    sequence = sequence';
end