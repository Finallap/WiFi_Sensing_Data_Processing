clc
clear
csi_trace=read_bf_file('G:\无源感知研究\数据采集\2019_04_02\sample_2_1.dat');
L=length(csi_trace);
amplitudeA=zeros(L,30);
amplitudeB=zeros(L,30);
amplitudeC=zeros(L,30);

phaseA=zeros(L,30);
phaseB=zeros(L,30);
phaseC=zeros(L,30);
for m=1:L
    csi_entry=csi_trace{m};
    csi=get_scaled_csi(csi_entry);
    
    %csi1=db(abs(squeeze(csi)));  %power
    csi1=abs(squeeze(csi));       %amplitude
    amplitudeA(m,:)=csi1(2,1,:);
    amplitudeB(m,:)=csi1(2,2,:);
    amplitudeC(m,:)=csi1(2,3,:);
    
    csi2=angle(squeeze(csi));    %phase
    phaseA(m,:)=csi2(1,1,:);
    phaseB(m,:)=csi2(1,2,:);
    phaseC(m,:)=csi2(1,3,:);
end



rssiA=zeros(L,1);
rssiB=zeros(L,1);
rssiC=zeros(L,1);
for m=1:L
    csi_entry=csi_trace{m};
    rssiA(m,1)=csi_entry.rssi_a;
    rssiB(m,1)=csi_entry.rssi_b;
    rssiC(m,1)=csi_entry.rssi_c;
    
end