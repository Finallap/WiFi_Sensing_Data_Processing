%��ȡ���ݼ���������options����Ԥ����
function [csi_train,csi_label] = dataset_reading_and_preprocessing(job_options)
    load(job_options.dataset_path);
    sample_num = size(csi_train,1);

    for i=1:sample_num
        amplitude = csi_train{i,1}';%�����н���ת��
        if(job_options.hampel_flag==true)
            amplitude = hampel(amplitude);%hampel�˲�
        end
        if(job_options.butterworth_flag==true)
            amplitude = wifi_butterworth_function(amplitude);%�����˲�
        end
        if(job_options.normalize_flag==true)
            amplitude = normalize(amplitude);%��һ������
        end
        csi_train{i,1}=amplitude;%д������
    end
    csi_label = categorical(csi_label(:,1));
end