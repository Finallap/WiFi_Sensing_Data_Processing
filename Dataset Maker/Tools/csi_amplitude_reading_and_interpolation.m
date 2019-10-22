function amplitude = csi_amplitude_reading_and_interpolation(filedirPath,start,the_end)
    csi_trace=read_bf_file(filedirPath);
    L=length(csi_trace);
    count_ntx3 = 0;

    original_timestamp_seq = zeros(L,1);
    for m=1:L
        csi_entry=csi_trace{m};
        if csi_entry.Ntx==3
            count_ntx3 = count_ntx3+1;
        end
        original_timestamp_seq(m)=csi_entry.timestamp_low;
    end
    
    original_timestamp_seq = unwrap(original_timestamp_seq,2^32);%原始的时间线进行时间戳解缠
    
    amplitudeA=zeros(count_ntx3,30);
    amplitudeB=zeros(count_ntx3,30);
    amplitudeC=zeros(count_ntx3,30);
    amplitudeA2=zeros(count_ntx3,30);
    amplitudeB2=zeros(count_ntx3,30);
    amplitudeC2=zeros(count_ntx3,30);
    amplitudeA3=zeros(count_ntx3,30);
    amplitudeB3=zeros(count_ntx3,30);
    amplitudeC3=zeros(count_ntx3,30);
    
    amplitude=zeros(270,count_ntx3);
    selected_timestamp_seq=zeros(count_ntx3,1);
    count_ntx3_i=1;
    
    for m=1:L
        csi_entry=csi_trace{m};
        csi=get_scaled_csi(csi_entry);

        if csi_entry.Ntx==3
            csi1=abs(squeeze(csi));       %amplitude
            amplitudeA(count_ntx3_i,:)=csi1(1,1,:);
            amplitudeB(count_ntx3_i,:)=csi1(1,2,:);
            amplitudeC(count_ntx3_i,:)=csi1(1,3,:);

            amplitudeA2(count_ntx3_i,:)=csi1(2,1,:);
            amplitudeB2(count_ntx3_i,:)=csi1(2,2,:);
            amplitudeC2(count_ntx3_i,:)=csi1(2,3,:);

            amplitudeA3(count_ntx3_i,:)=csi1(3,1,:);
            amplitudeB3(count_ntx3_i,:)=csi1(3,2,:);
            amplitudeC3(count_ntx3_i,:)=csi1(3,3,:);
            
            amplitude(1:30,count_ntx3_i)= amplitudeA(count_ntx3_i,:);
            amplitude(31:60,count_ntx3_i)= amplitudeA2(count_ntx3_i,:);
            amplitude(61:90,count_ntx3_i)=amplitudeA3(count_ntx3_i,:);
            amplitude(91:120,count_ntx3_i)=amplitudeB(count_ntx3_i,:);
            amplitude(121:150,count_ntx3_i)=amplitudeB2(count_ntx3_i,:);
            amplitude(151:180,count_ntx3_i)=amplitudeB3(count_ntx3_i,:);
            amplitude(181:210,count_ntx3_i)=amplitudeC(count_ntx3_i,:);
            amplitude(211:240,count_ntx3_i)=amplitudeC2(count_ntx3_i,:);
            amplitude(241:270,count_ntx3_i)=amplitudeC3(count_ntx3_i,:);

            selected_timestamp_seq(count_ntx3_i)=csi_entry.timestamp_low;

            count_ntx3_i = count_ntx3_i+1;
        end
    end

    %sep_timestamp_start = timestamp_seq(1);
    %sep_timestamp_end = timestamp_seq(end);
    
    selected_timestamp_seq = unwrap(selected_timestamp_seq,2^32);%选取的时间线进行时间戳解缠
    
    %以上部分将整段的序列进行了读取，接下来选取需要的部分进行插值
    %part_timestamp_start=csi_trace{start}.timestamp_low;
    %part_timestamp_end=csi_trace{the_end}.timestamp_low;
    part_timestamp_start = original_timestamp_seq(start);
    part_timestamp_end = original_timestamp_seq(the_end);
    
    interval = (csi_trace{L}.timestamp_low-csi_trace{1}.timestamp_low)/(L-1);
    interpolation_timestamp = (part_timestamp_start:interval:part_timestamp_end)';
    amplitude = interp1(selected_timestamp_seq, amplitude', interpolation_timestamp,'linear');
    amplitude = amplitude';
end