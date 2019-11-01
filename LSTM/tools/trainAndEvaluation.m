function [acc_count,precision_count,recall_count,f1_count,t_count] = trainAndEvaluation(csi_train,csi_label,job_options)
indices = crossvalind('Kfold',csi_label,job_options.Kfold);%划分训练集和测试集
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);

%预分配结果存储数组
acc_count = zeros(job_options.Kfold,1);
precision_count = zeros(job_options.Kfold,1);
recall_count = zeros(job_options.Kfold,1);
f1_count = zeros(job_options.Kfold,1);

for i = 1:job_options.Kfold
    tic;%预处理开始计时
    %划分此次的训练集和测试集
    test = (indices == i); 
    train = ~test;
    x_train = csi_train(train);
    y_train = csi_label(train);
    x_test = csi_train(test);
    y_test = csi_label(test);
    
    %对训练集进行排序
    [x_train,y_train] = sequenceSort(x_train,y_train);
    t_count.preprocessed(i) = toc;%预处理结束计时
    
    %使用LSTMMaker函数建立训练网络
    tic;%训练开始计时
    layers = LSTMMaker(job_options.networkType, job_options.inputSize, job_options.numHiddenUnits, job_options.numClasses);
    
    %训练网络
    net = trainLSTM(x_train,y_train,x_test,y_test,layers,job_options.maxEpochs);
    t_count.training(i) = toc;%训练结束计时
    
    %时间戳
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %保存网络
    networkSaveDir = sprintf('%s%s%d%s%s',job_options.result_save_dir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %预测并计算准确率
    tic;%预测开始计时
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred);
    acc_count(i) = acc;
    precision_count(i) = precision;
    recall_count(i) = recall;
    f1_count(i) = f1;
    t_count.prediction(i) = toc;%预测结束计时
    
    %绘制混淆矩阵
    figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
    cm = confusionchart(y_test,y_Pred);
    cm.Title = 'Confusion Matrix for Validation Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    %保存混淆矩阵
    confusionchartSaveDir = sprintf('%s%s%d%s%s',job_options.result_save_dir,'confusionchart(',i,')-',nowtimestr);
    saveas(gcf,confusionchartSaveDir);
    saveas(gcf,strcat(confusionchartSaveDir,'.jpg'));
end