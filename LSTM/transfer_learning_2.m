Kfold = 10;%设置交叉检验折数
indices = crossvalind('Kfold',csi_label,Kfold);%划分训练集和测试集
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);
saveDir = 'G:\无源感知研究\实验结果\2019_10_31_迁移学习\实验室 to 会议室 （Single200）4\';

% 初始化结果（使用cell结构，与输出同尺寸，每个元素对应Excel一个格子）
result_data = cell(2,9);
% 建立表头
title = {'迁移前平均Accuracy','迁移前平均Precision','迁移前平均Recall'...
    '迁移前平均F_score','迁移后平均Accuracy','迁移后平均Precision'...
    '迁移后平均Recall','迁移后平均F_score','迁移学习训练平均耗时'};
result_data(1,:)=title;

for i = 1:Kfold
    %划分此次的训练集和测试集
    test = (indices == i); 
    train = ~test;
    x_train = csi_train(train);
    y_train = csi_label(train);
    x_test = csi_train(test);
    y_test = csi_label(test);
    
    %对训练集进行排序
    [x_train,y_train] = sequenceSort(x_train,y_train);
    
    %训练网络
    tic;%训练开始计时
    net1 = trainLSTM(x_train,y_train,x_test,y_test,layers_1);
    t_count.training(i) = toc;%训练结束计时
    
    %时间戳
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %计算迁移前准确率
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [before_acc,before_precision,before_recall,before_f1]=indicator_calculation(y_Pred,y_test);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    before_acc_count(i) = before_acc;
    before_precision_count(i) = before_precision;
    before_recall_count(i) = before_recall;
    before_f1_count(i) = before_f1;
    
    %预测并计算准确率
    y_Pred = classify(net1,x_test, 'SequenceLength','longest');
    [after_acc,after_precision,after_recall,after_f1]=indicator_calculation(y_test,y_Pred);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    after_acc_count(i) = after_acc;
    after_precision_count(i) = after_precision;
    after_recall_count(i) = after_recall;
    after_f1_count(i) = after_f1;
    
    %绘制混淆矩阵
    figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
    cm = confusionchart(y_test,y_Pred);
    cm.Title = 'Confusion Matrix for Validation Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    %保存混淆矩阵
    confusionchartSaveDir = sprintf('%s%s%d%s%s',saveDir,'confusionchart(',i,')-',nowtimestr);
    saveas(gcf,confusionchartSaveDir);
    saveas(gcf,strcat(confusionchartSaveDir,'.jpg'));
end

result_data(2,1)=num2cell(mean(before_acc_count));%迁移前平均Accuracy
result_data(2,2)=num2cell(mean(before_precision_count));%迁移前平均Precision
result_data(2,3)=num2cell(mean(before_recall_count));%迁移前平均Recall
result_data(2,4)=num2cell(mean(before_f1_count));%迁移前平均F_score
result_data(2,5)=num2cell(mean(after_acc_count));%迁移后平均Accuracy
result_data(2,6)=num2cell(mean(after_precision_count));%迁移后平均Precision
result_data(2,7)=num2cell(mean(after_recall_count));%迁移后平均Recall
result_data(2,8)=num2cell(mean(after_f1_count));%迁移后平均F_score
result_data(2,9)=num2cell(mean(t_count.training));%迁移学习训练平均耗时

function [x_train,y_train] = sequenceSort(x_train,y_train)
    numObservations = numel(x_train);
    for i=1:numObservations
        sequence = x_train{i};
        sequenceLengths(i) = size(sequence,2);
    end

    [~,idx] = sort(sequenceLengths);
    x_train = x_train(idx);
    y_train = y_train(idx);
end

function net = trainLSTM(x_train,y_train,x_test,y_test,layers_1)
maxEpochs = 15;
miniBatchSize = 32;

options = trainingOptions('adam', ...
        'ExecutionEnvironment','auto', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize', ...
        'SequenceLength','longest', ...
        'Verbose',0, ...
        'ValidationData',{x_test,y_test}, ...
        'ValidationFrequency',5, ...
        'InitialLearnRate',1e-3, ...
        'Plots','training-progress');
    
net = trainNetwork(x_train,y_train,layers_1,options);
end