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