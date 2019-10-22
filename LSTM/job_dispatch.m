job_options.dataset_dir = 'G:\无源感知研究\数据采集\2019_07_18\';
job_options.dataset_filename = '会议室(3t3r)(1)';
job_options.result_dir = 'G:\无源感知研究\实验结果\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'DoubleBiLSTM';
job_options.numHiddenUnits = 128;
job_options.numClasses = 6;
job_options.maxEpochs = 40;

result_save_dir = make_result_dir(job_options);
%[csi_train,csi_label] = dataset_reading_and_preprocessing(job_options);


%创建实验结果文件夹，并返回路径
function result_save_dir = make_result_dir(job_options)
    nowtime = fix(clock);
    datestr = sprintf('%d_%d_%d',nowtime(1),nowtime(2),nowtime(3));
    dir_name = strcat(datestr,'_',job_options.dataset_filename);
    if(job_options.hampel_flag==true)
        dir_name = strcat(dir_name,'_hampel');
    end
    if(job_options.butterworth_flag==true)
        dir_name = strcat(dir_name,'_butterworth');
    end
    if(job_options.normalize_flag==true)
        dir_name = strcat(dir_name,'_normalize');
    end
    result_save_dir = strcat(job_options.result_dir ,dir_name, '\');
    mkdir(result_save_dir);
end

function [csi_train,csi_label] = dataset_reading_and_preprocessing(job_options)
    load(job_options.dataset_path);
    sample_num = size(csi_train,1);

    for i=1:sample_num
        amplitude = csi_train{i,1}';%对序列进行转置
        if(job_options.hampel_flag==true)
            amplitude = hampel(amplitude);%hampel滤波
        end
        if(job_options.butterworth_flag==true)
            amplitude = wifi_butterworth_function(amplitude);%进行滤波
        end
        if(job_options.normalize_flag==true)
            amplitude = normalize(amplitude);%归一化处理
        end
        csi_train{i,1}=amplitude;%写回序列
    end
    csi_label = categorical(csi_label(:,1));
end

