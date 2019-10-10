function phase = csi_phase_reading(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    phase=zeros(180,L);
    
    phaseA=zeros(L,30);
    phaseB=zeros(L,30);
    phaseC=zeros(L,30);
    phaseA2=zeros(L,30);
    phaseB2=zeros(L,30);
    phaseC2=zeros(L,30);
    
    for m=1:L
        csi_entry=csi_trace{m};
        csi=get_scaled_csi(csi_entry);
        csi2=angle(squeeze(csi));    %phase
        
        phaseA(m,:)=csi2(1,1,:);
        phaseB(m,:)=csi2(1,2,:);
        phaseC(m,:)=csi2(1,3,:);
    
        phaseA2(m,:)=csi2(2,1,:);
        phaseB2(m,:)=csi2(2,2,:);
        phaseC2(m,:)=csi2(2,3,:);
        
        phase(1:30,m)= phaseA(m,:);
        phase(31:60,m)= phaseA2(m,:);
        phase(61:90,m)=phaseB(m,:);
        phase(91:120,m)=phaseB2(m,:);
        phase(121:150,m)=phaseC(m,:);
        phase(151:180,m)=phaseC2(m,:);
    end
end