job_options.dataset_dir = 'G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\';
job_options.dataset_filename = '������(3t3r)(1)';
job_options.result_dir = 'G:\��Դ��֪�о�\ʵ����\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'DoubleBiLSTM';
job_options.inputSize = 270;
job_options.numHiddenUnits = 128;
job_options.numClasses = 6;
job_options.maxEpochs = 40;
job_options.isLrReduce = true;
job_options.Kfold = 10;%�����������

result_save_dir = make_result_dir(job_options);
job_options.result_save_dir = result_save_dir;
%[csi_train,csi_label] = dataset_reading_and_preprocessing(job_options);

% ��ʼ�������ʹ��cell�ṹ�������ͬ�ߴ磬ÿ��Ԫ�ض�ӦExcelһ�����ӣ�
result_data = cell(2,22);
% ������ͷ
title = {'ѵ����ʼʱ��','ѵ������ʱ��','���ݼ�','��������ά��','ģ������','��������'...
    '��������','�Ƿ�ѧϰ���½�','�Ƿ�hampel�˲�','�Ƿ��ͨ�˲�','�Ƿ��һ��'...
    '1','2','3','4','5','6','7','8','9','10','ƽ��׼ȷ��'};
result_data(1,:)=title;

result_data(2,1)=cellstr(getNowTimeStr());%��¼ѵ����ʼʱ��

%��ʼѵ��
%[acc_count] = trainAndEvaluation(job_options);

result_data(2,2)=cellstr(getNowTimeStr());%��¼ѵ������ʱ��
result_data(2,3)=cellstr(job_options.dataset_filename);%���ݼ�
result_data(2,4)=num2cell(job_options.inputSize);%��������ά��
result_data(2,5)=cellstr(job_options.networkType);%ģ������
result_data(2,6)=num2cell(job_options.numHiddenUnits);%��������
result_data(2,7)=num2cell(job_options.maxEpochs);%��������
result_data(2,8)=num2cell(job_options.isLrReduce);%�Ƿ�ѧϰ���½�
result_data(2,9)=num2cell(job_options.hampel_flag);%�Ƿ�hampel�˲�
result_data(2,10)=num2cell(job_options.butterworth_flag);%�Ƿ��ͨ�˲�
result_data(2,11)=num2cell(job_options.normalize_flag);%�Ƿ��һ��
result_data(2,12:21)=num2cell(acc_count());%׼ȷ��
result_data(2,22)=num2cell(mean(acc_count));%ƽ��׼ȷ��

result_xls_path = strcat(job_options.result_dir,'result.xls');
xlswrite(result_xls_path, result_data);