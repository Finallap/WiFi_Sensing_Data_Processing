%输入任务数量，预先建立jobs
job_num = 2;
jobs =cell(job_num,1);

%-----------------------从这里开始改各种配置------------------------%
job_options.dataset_dir = 'G:\无源感知研究\数据采集\2019_07_18\';
job_options.dataset_filename = '实验室(3t3r)(1)';
job_options.result_dir = 'G:\无源感知研究\实验结果\2019_11_07_resample\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.resample_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'SingleBiLSTM';
job_options.inputSize = 270;
job_options.numHiddenUnits = 150;
job_options.numClasses = 6;
job_options.maxEpochs = 30;
job_options.isLrReduce = true;
job_options.Kfold = 10;%交叉检验折数

jobs(1,1) = {job_options};
%-----------------------到这里配置结束，并塞入jobs------------------------%

%-----------------------从这里开始改各种配置------------------------%
job_options.dataset_dir = 'G:\无源感知研究\数据采集\2019_07_18\';
job_options.dataset_filename = '会议室(3t3r)(1)';
job_options.result_dir = 'G:\无源感知研究\实验结果\2019_11_07_resample\';

job_options.dataset_path = sprintf('%s%s%s',job_options.dataset_dir,job_options.dataset_filename,'.mat');
job_options.hampel_flag = true;
job_options.butterworth_flag = true;
job_options.resample_flag = true;
job_options.normalize_flag =true;

job_options.networkType = 'SingleBiLSTM';
job_options.inputSize = 270;
job_options.numHiddenUnits = 150;
job_options.numClasses = 6;
job_options.maxEpochs = 30;
job_options.isLrReduce = true;
job_options.Kfold = 10;%交叉检验折数

jobs(2,1) = {job_options};
%-----------------------到这里配置结束，并塞入jobs------------------------%

% 初始化结果（使用cell结构，与输出同尺寸，每个元素对应Excel一个格子）
result_data = cell(job_num+1,29);
% 建立表头
title = {'训练开始时间','训练结束时间','数据集','输入数据维数','模型类型','隐层数量'...
    '迭代次数','是否学习率下降','是否hampel滤波','是否低通滤波','是否重采样','是否归一化'...
    '1','2','3','4','5','6','7','8','9','10','平均Accuracy','平均Precision'...
    '平均Recall','平均F_score','预处理平均耗时','训练平均耗时','评估平均耗时'};
result_data(1,:)=title;

%循环调度任务
for i = 1:job_num
    result_data(i+1,1)=cellstr(getNowTimeStr());%记录训练开始时间

    %创建结果保存文件夹，并开始数据预处理
    tic;
    result_save_dir = make_result_dir(jobs{i,1});%创建结果保存文件夹
    jobs{i,1}.result_save_dir = result_save_dir;
    [csi_train,csi_label] = dataset_reading_and_preprocessing(jobs{i,1});%数据预处理
    t.preprocessed = toc;

    %开始训练
    [acc_count,precision_count,recall_count,f1_count,t_count] = trainAndEvaluation(csi_train,csi_label,jobs{i,1});%训练网络，返回结果

    result_data(i+1,2)=cellstr(getNowTimeStr());%记录训练结束时间
    result_data(i+1,3)=cellstr(jobs{i,1}.dataset_filename);%数据集
    result_data(i+1,4)=num2cell(jobs{i,1}.inputSize);%输入数据维数
    result_data(i+1,5)=cellstr(jobs{i,1}.networkType);%模型类型
    result_data(i+1,6)=num2cell(jobs{i,1}.numHiddenUnits);%隐层数量
    result_data(i+1,7)=num2cell(jobs{i,1}.maxEpochs);%迭代次数
    result_data(i+1,8)=num2cell(jobs{i,1}.isLrReduce);%是否学习率下降
    result_data(i+1,9)=num2cell(jobs{i,1}.hampel_flag);%是否hampel滤波
    result_data(i+1,10)=num2cell(jobs{i,1}.butterworth_flag);%是否低通滤波
    result_data(i+1,11)=num2cell(jobs{i,1}.butterworth_flag);%是否重采样
    result_data(i+1,12)=num2cell(jobs{i,1}.normalize_flag);%是否归一化
    result_data(i+1,13:22)=num2cell(acc_count());%准确度
    result_data(i+1,23)=num2cell(mean(acc_count));%平均准确度
    result_data(i+1,24)=num2cell(mean(precision_count));%平均precision
    result_data(i+1,25)=num2cell(mean(recall_count));%平均recall
    result_data(i+1,26)=num2cell(mean(f1_count));%平均f1
    result_data(i+1,27)=num2cell(t.preprocessed + mean(t_count.preprocessed));%预处理平均耗时
    result_data(i+1,28)=num2cell(mean(t_count.training));%训练平均耗时
    result_data(i+1,29)=num2cell(mean(t_count.prediction));%评估平均耗时
end

nowtime = fix(clock);
nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
result_xls_path = strcat(jobs{i,1}.result_dir,'result-',nowtimestr,'.xls');
xlswrite(result_xls_path, result_data);