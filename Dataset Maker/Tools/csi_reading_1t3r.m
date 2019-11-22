function [amplitude,phase,rssi] = csi_reading_1t3r(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    amplitude=zeros(L,90);
    phase=zeros(L,90);
    rssi=zeros(L,3);
    
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

        amplitude(m,1:30)= amplitudeA(m,:);
        amplitude(m,31:60)= amplitudeB(m,:);
        amplitude(m,61:90)=amplitudeC(m,:);
        
        csi2=angle(squeeze(csi));    %phase
        phaseA(m,:)=phase_processing(csi2(1,:));
        phaseB(m,:)=phase_processing(csi2(2,:));
        phaseC(m,:)=phase_processing(csi2(3,:));
        
        phase(m,1:30)= phaseA(m,:);
        phase(m,31:60)= phaseB(m,:);
        phase(m,61:90)=phaseC(m,:);
        
        rssiA(m,1)=csi_entry.rssi_a;    %rssi
        rssiB(m,1)=csi_entry.rssi_b;
        rssiC(m,1)=csi_entry.rssi_c;
        
        rssi(m,1)=rssiA(m,1);
        rssi(m,2)=rssiB(m,1);
        rssi(m,3)=rssiC(m,1);
    end
end

function phase = phase_processing(phase)
    for i=1:size(phase,1)
        phase(i,:)=sanitize_phase(phase(i,:));
    end
end