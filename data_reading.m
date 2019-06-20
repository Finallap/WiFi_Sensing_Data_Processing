clear
csi_trace=read_bf_file('G:\无源感知研究\数据采集\2019_06_01_WiFiRadar\bend_sheng_2.dat');

%tx=2;
%rx=3;
L=length(csi_trace);

%amplitude=zeros(tx,rx,30,L);
amplitudeA=zeros(L,30);
amplitudeB=zeros(L,30);
amplitudeC=zeros(L,30);
amplitudeA2=zeros(L,30);
amplitudeB2=zeros(L,30);
amplitudeC2=zeros(L,30);

phaseA=zeros(L,30);
phaseB=zeros(L,30);
phaseC=zeros(L,30);
phaseA2=zeros(L,30);
phaseB2=zeros(L,30);
phaseC2=zeros(L,30);

for m=1:L
    csi_entry=csi_trace{m};
    csi=get_scaled_csi(csi_entry);
    
    %csi1=db(abs(squeeze(csi)));  %power
    csi1=abs(squeeze(csi));       %amplitude
    amplitudeA(m,:)=csi1(1,1,:);
    amplitudeB(m,:)=csi1(1,2,:);
    amplitudeC(m,:)=csi1(1,3,:);
    
    amplitudeA2(m,:)=csi1(2,1,:);
    amplitudeB2(m,:)=csi1(2,2,:);
    amplitudeC2(m,:)=csi1(2,3,:);
    
    csi2=angle(squeeze(csi));    %phase
    phaseA(m,:)=csi2(1,1,:);
    phaseB(m,:)=csi2(1,2,:);
    phaseC(m,:)=csi2(1,3,:);
    
    phaseA2(m,:)=csi2(2,1,:);
    phaseB2(m,:)=csi2(2,2,:);
    phaseC2(m,:)=csi2(2,3,:);
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