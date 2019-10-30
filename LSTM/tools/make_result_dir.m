%创建实验结果文件夹，并返回路径
function result_save_dir = make_result_dir(job_options)
    nowtime = fix(clock);
    datestr = sprintf('%d_%d_%d',nowtime(1),nowtime(2),nowtime(3));
    dir_name = strcat(datestr,'_',job_options.dataset_filename);
    dir_name = strcat(dir_name,'_',num2str(job_options.numHiddenUnits),'unit');
    dir_name = strcat(dir_name,'_',job_options.networkType);
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