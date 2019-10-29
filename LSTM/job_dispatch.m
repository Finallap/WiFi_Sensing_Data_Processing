%��������������Ԥ�Ƚ���jobs
job_num = 2;
jobs =cell(job_num,1);

%-----------------------�����￪ʼ�ĸ�������------------------------%
job_options.dataset_dir = 'G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\';
job_options.dataset_filename = '������(3t3r)(1)';
job_options.result_dir = 'G:\��Դ��֪�о�\ʵ����\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'SingleBiLSTM';
job_options.inputSize = 270;
job_options.numHiddenUnits = 200;
job_options.numClasses = 6;
job_options.maxEpochs = 30;
job_options.isLrReduce = true;
job_options.Kfold = 10;%�����������

jobs(1,1) = {job_options};
%-----------------------���������ý�����������jobs------------------------%

%-----------------------�����￪ʼ�ĸ�������------------------------%
job_options.dataset_dir = 'G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\';
job_options.dataset_filename = 'ʵ����(3t3r)(1)';
job_options.result_dir = 'G:\��Դ��֪�о�\ʵ����\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'SingleBiLSTM';
job_options.inputSize = 270;
job_options.numHiddenUnits = 200;
job_options.numClasses = 6;
job_options.maxEpochs = 30;
job_options.isLrReduce = true;
job_options.Kfold = 10;%�����������

jobs(2,1) = {job_options};
%-----------------------���������ý�����������jobs------------------------%

% ��ʼ�������ʹ��cell�ṹ�������ͬ�ߴ磬ÿ��Ԫ�ض�ӦExcelһ�����ӣ�
result_data = cell(job_num+1,28);
% ������ͷ
title = {'ѵ����ʼʱ��','ѵ������ʱ��','���ݼ�','��������ά��','ģ������','��������'...
    '��������','�Ƿ�ѧϰ���½�','�Ƿ�hampel�˲�','�Ƿ��ͨ�˲�','�Ƿ��һ��'...
    '1','2','3','4','5','6','7','8','9','10','ƽ��Accuracy','ƽ��Precision'...
    'ƽ��Recall','ƽ��F_score','Ԥ����ƽ����ʱ','ѵ��ƽ����ʱ','����ƽ����ʱ'};
result_data(1,:)=title;

%ѭ����������
for i = 1:job_num
    result_data(i+1,1)=cellstr(getNowTimeStr());%��¼ѵ����ʼʱ��

    %������������ļ��У�����ʼ����Ԥ����
    tic;
    result_save_dir = make_result_dir(jobs{i,1});%������������ļ���
    jobs{i,1}.result_save_dir = result_save_dir;
    [csi_train,csi_label] = dataset_reading_and_preprocessing(jobs{i,1});%����Ԥ����
    t.preprocessed = toc;

    %��ʼѵ��
    [acc_count,precision_count,recall_count,f1_count,t_count] = trainAndEvaluation(csi_train,csi_label,jobs{i,1});%ѵ�����磬���ؽ��

    result_data(i+1,2)=cellstr(getNowTimeStr());%��¼ѵ������ʱ��
    result_data(i+1,3)=cellstr(jobs{i,1}.dataset_filename);%���ݼ�
    result_data(i+1,4)=num2cell(jobs{i,1}.inputSize);%��������ά��
    result_data(i+1,5)=cellstr(jobs{i,1}.networkType);%ģ������
    result_data(i+1,6)=num2cell(jobs{i,1}.numHiddenUnits);%��������
    result_data(i+1,7)=num2cell(jobs{i,1}.maxEpochs);%��������
    result_data(i+1,8)=num2cell(jobs{i,1}.isLrReduce);%�Ƿ�ѧϰ���½�
    result_data(i+1,9)=num2cell(jobs{i,1}.hampel_flag);%�Ƿ�hampel�˲�
    result_data(i+1,10)=num2cell(jobs{i,1}.butterworth_flag);%�Ƿ��ͨ�˲�
    result_data(i+1,11)=num2cell(jobs{i,1}.normalize_flag);%�Ƿ��һ��
    result_data(i+1,12:21)=num2cell(acc_count());%׼ȷ��
    result_data(i+1,22)=num2cell(mean(acc_count));%ƽ��׼ȷ��
    result_data(i+1,23)=num2cell(mean(precision_count));%ƽ��precision
    result_data(i+1,24)=num2cell(mean(recall_count));%ƽ��recall
    result_data(i+1,25)=num2cell(mean(f1_count));%ƽ��f1
    result_data(i+1,26)=num2cell(t.preprocessed + mean(t_count.preprocessed));%Ԥ����ƽ����ʱ
    result_data(i+1,27)=num2cell(mean(t_count.training));%ѵ��ƽ����ʱ
    result_data(i+1,28)=num2cell(mean(t_count.prediction));%����ƽ����ʱ
end

nowtime = fix(clock);
nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
result_xls_path = strcat(jobs{i,1}.result_dir,'result-',nowtimestr,'.xls');
xlswrite(result_xls_path, result_data);