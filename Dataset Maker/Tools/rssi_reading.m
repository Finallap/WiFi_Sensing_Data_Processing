function rssi = rssi_reading(filedirPath)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    rssi=zeros(3,L);

    for m=1:L
        csi_entry=csi_trace{m};

        rssi(1,m)=csi_entry.rssi_a;
        rssi(2,m)=csi_entry.rssi_b;
        rssi(3,m)=csi_entry.rssi_c;
    end
end