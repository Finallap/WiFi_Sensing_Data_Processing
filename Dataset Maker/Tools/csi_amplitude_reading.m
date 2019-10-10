function amplitude = csi_amplitude_reading(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    amplitude=zeros(180,L);
    
    amplitudeA=zeros(L,30);
    amplitudeB=zeros(L,30);
    amplitudeC=zeros(L,30);
    amplitudeA2=zeros(L,30);
    amplitudeB2=zeros(L,30);
    amplitudeC2=zeros(L,30);

    for m=1:L
        csi_entry=csi_trace{m};
        csi=get_scaled_csi(csi_entry);
        csi1=abs(squeeze(csi));       %amplitude
        
        amplitudeA(m,:)=csi1(1,1,:);
        amplitudeB(m,:)=csi1(1,2,:);
        amplitudeC(m,:)=csi1(1,3,:);
    
        amplitudeA2(m,:)=csi1(2,1,:);
        amplitudeB2(m,:)=csi1(2,2,:);
        amplitudeC2(m,:)=csi1(2,3,:);
        
        amplitude(1:30,m)= amplitudeA(m,:);
        amplitude(31:60,m)= amplitudeA2(m,:);
        amplitude(61:90,m)=amplitudeB(m,:);
        amplitude(91:120,m)=amplitudeB2(m,:);
        amplitude(121:150,m)=amplitudeC(m,:);
        amplitude(151:180,m)=amplitudeC2(m,:);
    end
end