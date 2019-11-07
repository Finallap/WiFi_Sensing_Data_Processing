%读取数据集，并根据options进行预处理
function [csi_train,csi_label] = dataset_reading_and_preprocessing(job_options)
    load(job_options.dataset_path);
    sample_num = size(csi_train,1);
    
    %求出各个序列的长度
    sequenceLengths = zeros(sample_num,1);
    for i=1:sample_num
        sequenceLengths(i) = size(csi_train{i},1);
    end
    
    for i=1:sample_num
        amplitude = csi_train{i,1}';%对序列进行转置
        if(job_options.hampel_flag==true)
            amplitude = hampel(amplitude);%hampel滤波
        end
        if(job_options.butterworth_flag==true)
            amplitude = wifi_butterworth_function(amplitude);%进行滤波
        end
        if(job_options.resample_flag==true)
            amplitude = resample(amplitude',ceil(mean(sequenceLengths)),size(amplitude,2));
            amplitude = amplitude';
        end
        if(job_options.normalize_flag==true)
            amplitude = normalize(amplitude);%归一化处理
        end
        csi_train{i,1}=amplitude;%写回序列
    end
    csi_label = categorical(csi_label(:,1));
end