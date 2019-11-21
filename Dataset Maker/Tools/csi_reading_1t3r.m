function [amplitude,phase,rssi] = csi_reading_1t3r(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    amplitude=zeros(90,L);
    phase=zeros(90,L);
    rssi=zeros(3,L);
    
    amplitudeA=zeros(L,30);
    amplitudeB=zeros(L,30);
    amplitudeC=zeros(L,30);

    phaseA=zeros(L,30);
    phaseB=zeros(L,30);
    phaseC=zeros(L,30);
    
    rssiA=zeros(L,1);
    rssiB=zeros(L,1);
    rssiC=zeros(L,1);
    
    for m=1:L
        csi_entry=csi_trace{m};
        csi=get_scaled_csi(csi_entry);
        
        csi1=abs(squeeze(csi));%amplitude
        amplitudeA(m,:)=csi1(1,:);
        amplitudeB(m,:)=csi1(2,:);
        amplitudeC(m,:)=csi1(3,:);

        amplitude(1:30,m)= amplitudeA(m,:);
        amplitude(31:60,m)= amplitudeB(m,:);
        amplitude(61:90,m)=amplitudeC(m,:);
        
        csi2=angle(squeeze(csi));    %phase
        phaseA(m,:)=csi2(1,:);
        phaseB(m,:)=csi2(2,:);
        phaseC(m,:)=csi2(3,:);
        
        phase(1:30,m)= phaseA(m,:);
        phase(31:60,m)= phaseB(m,:);
        phase(61:90,m)=phaseC(m,:);
        
        rssiA(m,1)=csi_entry.rssi_a;    %rssi
        rssiB(m,1)=csi_entry.rssi_b;
        rssiC(m,1)=csi_entry.rssi_c;
        
        rssi(1,m)=rssiA(m,1);
        rssi(2,m)=rssiB(m,1);
        rssi(3,m)=rssiC(m,1);
    end
end