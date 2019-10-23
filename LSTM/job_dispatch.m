job_options.dataset_dir = 'G:\无源感知研究\数据采集\2019_07_18\';
job_options.dataset_filename = '会议室(3t3r)(1)';
job_options.result_dir = 'G:\无源感知研究\实验结果\';

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
job_options.Kfold = 10;%交叉检验折数

result_save_dir = make_result_dir(job_options);
job_options.result_save_dir = result_save_dir;
%[csi_train,csi_label] = dataset_reading_and_preprocessing(job_options);

% 初始化结果（使用cell结构，与输出同尺寸，每个元素对应Excel一个格子）
result_data = cell(2,22);
% 建立表头
title = {'训练开始时间','训练结束时间','数据集','输入数据维数','模型类型','隐层数量'...
    '迭代次数','是否学习率下降','是否hampel滤波','是否低通滤波','是否归一化'...
    '1','2','3','4','5','6','7','8','9','10','平均准确度'};
result_data(1,:)=title;

result_data(2,1)=cellstr(getNowTimeStr());%记录训练开始时间

%开始训练
%[acc_count] = trainAndEvaluation(job_options);

result_data(2,2)=cellstr(getNowTimeStr());%记录训练结束时间
result_data(2,3)=cellstr(job_options.dataset_filename);%数据集
result_data(2,4)=num2cell(job_options.inputSize);%输入数据维数
result_data(2,5)=cellstr(job_options.networkType);%模型类型
result_data(2,6)=num2cell(job_options.numHiddenUnits);%隐层数量
result_data(2,7)=num2cell(job_options.maxEpochs);%迭代次数
result_data(2,8)=num2cell(job_options.isLrReduce);%是否学习率下降
result_data(2,9)=num2cell(job_options.hampel_flag);%是否hampel滤波
result_data(2,10)=num2cell(job_options.butterworth_flag);%是否低通滤波
result_data(2,11)=num2cell(job_options.normalize_flag);%是否归一化
result_data(2,12:21)=num2cell(acc_count());%准确度
result_data(2,22)=num2cell(mean(acc_count));%平均准确度

result_xls_path = strcat(job_options.result_dir,'result.xls');
xlswrite(result_xls_path, result_data);