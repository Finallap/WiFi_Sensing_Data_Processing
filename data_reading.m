%clear
csi_trace=read_bf_file('G:\无源感知研究\数据采集\2019_07_18\会议室\clap_fang_1.dat');

%tx=2;
%rx=3;
L=length(csi_trace);
count_ntx1 = 0;
count_ntx2 = 0;
count_ntx3 = 0;
ntx3_seq = zeros(L,1);
ntx3_seq_string = '';

%csiA=zeros(L,30);
%csiB=zeros(L,30);
%csiC=zeros(L,30);
%csiA2=zeros(L,30);
%csiB2=zeros(L,30);
%csiC2=zeros(L,30);

%amplitude=zeros(tx,rx,30,L);
amplitudeA=zeros(L,30);
amplitudeB=zeros(L,30);
amplitudeC=zeros(L,30);
amplitudeA2=zeros(L,30);
amplitudeB2=zeros(L,30);
amplitudeC2=zeros(L,30);
%amplitudeA3=zeros(L,30);
%amplitudeB3=zeros(L,30);
%amplitudeC3=zeros(L,30);

phaseA=zeros(L,30);
phaseB=zeros(L,30);
phaseC=zeros(L,30);
phaseA2=zeros(L,30);
phaseB2=zeros(L,30);
phaseC2=zeros(L,30);

rssiA=zeros(L,1);
rssiB=zeros(L,1);
rssiC=zeros(L,1);

for m=1:L
    csi_entry=csi_trace{m};
    csi=get_scaled_csi(csi_entry);
    
    if csi_entry.Ntx==1
        count_ntx1 = count_ntx1+1;
        ntx3_seq_string =strcat(ntx3_seq_string,'0');
    elseif csi_entry.Ntx==2
        count_ntx2 = count_ntx2+1;
        ntx3_seq_string =strcat(ntx3_seq_string,'0');
    elseif csi_entry.Ntx==3
        count_ntx3 = count_ntx3+1;
        ntx3_seq(m) = 1;
        ntx3_seq_string =strcat(ntx3_seq_string,'1');
    end
    
    %original csi
    %csiA(m,:)=csi_entry.csi(1,1,:);
    %csiB(m,:)=csi_entry.csi(1,2,:);
    %csiC(m,:)=csi_entry.csi(1,3,:);
    
    %csiA2(m,:)=csi_entry.csi(2,1,:);
    %csiB2(m,:)=csi_entry.csi(2,2,:);
    %csiC2(m,:)=csi_entry.csi(2,3,:);
    
    %csi1=db(abs(squeeze(csi)));  %power
    csi1=abs(squeeze(csi));       %amplitude
    amplitudeA(m,:)=csi1(1,1,:);
    amplitudeB(m,:)=csi1(1,2,:);
    amplitudeC(m,:)=csi1(1,3,:);
    
    amplitudeA2(m,:)=csi1(2,1,:);
    amplitudeB2(m,:)=csi1(2,2,:);
    amplitudeC2(m,:)=csi1(2,3,:);
    
    %amplitudeA3(m,:)=csi1(3,1,:);
    %amplitudeB3(m,:)=csi1(3,2,:);
    %amplitudeC3(m,:)=csi1(3,3,:);
    
    csi2=angle(squeeze(csi));    %phase
    phaseA(m,:)=csi2(1,1,:);
    phaseB(m,:)=csi2(1,2,:);
    phaseC(m,:)=csi2(1,3,:);
    
    phaseA2(m,:)=csi2(2,1,:);
    phaseB2(m,:)=csi2(2,2,:);
    phaseC2(m,:)=csi2(2,3,:);
    
    rssiA(m,1)=csi_entry.rssi_a;
    rssiB(m,1)=csi_entry.rssi_b;
    rssiC(m,1)=csi_entry.rssi_c;
end


ampA=zeros(count_ntx3,30);
ampB=zeros(count_ntx3,30);
ampC=zeros(count_ntx3,30);
ampA2=zeros(count_ntx3,30);
ampB2=zeros(count_ntx3,30);
ampC2=zeros(count_ntx3,30);
ampA3=zeros(count_ntx3,30);
ampB3=zeros(count_ntx3,30);
ampC3=zeros(count_ntx3,30);
timestamp_seq=zeros(count_ntx3,1);
count_ntx3_i=1;

for m=1:L
    csi_entry=csi_trace{m};
    csi=get_scaled_csi(csi_entry);
    
    if csi_entry.Ntx==3
        csi1=abs(squeeze(csi));       %amplitude
        ampA(count_ntx3_i,:)=csi1(1,1,:);
        ampB(count_ntx3_i,:)=csi1(1,2,:);
        ampC(count_ntx3_i,:)=csi1(1,3,:);
    
        ampA2(count_ntx3_i,:)=csi1(2,1,:);
        ampB2(count_ntx3_i,:)=csi1(2,2,:);
        ampC2(count_ntx3_i,:)=csi1(2,3,:);
    
        ampA3(count_ntx3_i,:)=csi1(3,1,:);
        ampB3(count_ntx3_i,:)=csi1(3,2,:);
        ampC3(count_ntx3_i,:)=csi1(3,3,:);
        
        timestamp_seq(count_ntx3_i)=csi_entry.timestamp_low;
        
        count_ntx3_i = count_ntx3_i+1;
    end
end

max_gap = max(strlength(regexp(ntx3_seq_string,'0*','match')));
%plot(ntx3_seq)
%title("会议室\bend_chen_2")

timestamp_start = timestamp_seq(1);
timestamp_end = timestamp_seq(end);
gap=diff(timestamp_seq);
interval = (csi_trace{L}.timestamp_low-csi_trace{1}.timestamp_low)/L;
xq = (timestamp_start:interval:timestamp_end)';
V = interp1(timestamp_seq, ampA, xq,'linear');

hold on
subplot(3,1,1);
plot(ntx3_seq)
subplot(3,1,2);
plot(amplitudeA(:,:))
subplot(3,1,3);
plot(V(:,:))
hold off