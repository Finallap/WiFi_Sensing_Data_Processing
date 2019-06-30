%���źŽ��а�����˹�˲�
%      sequence = # ��������ź�����
%      fs = # ����Ƶ��
%      wp = # ͨ����ֹƵ��
%      ws = # �����ֹƵ��
%      rp = # ͨ�����˥��
%      as = # �����С˥��
%
% (c) 2019 Fang Yuanrun
%
function sequence=wifi_butterworth(sequence,fs,wp,ws,rp,as)
wp=2*wp/fs;         %��ͨ����ֹƵ��
ws=2*ws/fs;         %�������ֹƵ��
[N,wc]=buttord(wp,ws,rp,as);    %wp��ͨ����ֹƵ�ʣ�ws�������ֹƵ�ʡ���Ҫ���Բ����ʵ�һ����й�һ��������Ϊ��0-1�� rp��as��ͨ���������˥��
[B,A]=butter(N,wc);         %n���˲����Ľ�����wc�ǽ�ֹƵ�ʣ�wc = ��ֹƵ��*2/����Ƶ��
[H,W]=freqz(B,A);       %[H��W] = freqz��b��a��n������n�㸴Ƶ��Ӧʸ��H��n���Ƶ������w��b��aΪϵͳ���ݺ����ķ��Ӻͷ�ĸ��ϵ�����������nû��ָ����Ĭ��Ϊ512��
for i=1:30
    m_aB = mean(sequence(:,i));
    x = sequence(:,i)-m_aB;
    sequence(:,i) = filter(B,A,x)+m_aB;        %����xΪ�˲�ǰ���У�������˲�������У�B/A �ṩ�˲���ϵ����BΪ���ӣ�AΪ��ĸ 
end