Kfold = 10;%���ý����������
indices = crossvalind('Kfold',csi_label,Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);
saveDir = 'G:\��Դ��֪�о�\ʵ����\2019_10_31_Ǩ��ѧϰ\ʵ���� to ������ ��Single200��4\';

% ��ʼ�������ʹ��cell�ṹ�������ͬ�ߴ磬ÿ��Ԫ�ض�ӦExcelһ�����ӣ�
result_data = cell(2,9);
% ������ͷ
title = {'Ǩ��ǰƽ��Accuracy','Ǩ��ǰƽ��Precision','Ǩ��ǰƽ��Recall'...
    'Ǩ��ǰƽ��F_score','Ǩ�ƺ�ƽ��Accuracy','Ǩ�ƺ�ƽ��Precision'...
    'Ǩ�ƺ�ƽ��Recall','Ǩ�ƺ�ƽ��F_score','Ǩ��ѧϰѵ��ƽ����ʱ'};
result_data(1,:)=title;

for i = 1:Kfold
    %���ִ˴ε�ѵ�����Ͳ��Լ�
    test = (indices == i); 
    train = ~test;
    x_train = csi_train(train);
    y_train = csi_label(train);
    x_test = csi_train(test);
    y_test = csi_label(test);
    
    %��ѵ������������
    [x_train,y_train] = sequenceSort(x_train,y_train);
    
    %ѵ������
    tic;%ѵ����ʼ��ʱ
    net1 = trainLSTM(x_train,y_train,x_test,y_test,layers_1);
    t_count.training(i) = toc;%ѵ��������ʱ
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %����Ǩ��ǰ׼ȷ��
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [before_acc,before_precision,before_recall,before_f1]=indicator_calculation(y_Pred,y_test);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    before_acc_count(i) = before_acc;
    before_precision_count(i) = before_precision;
    before_recall_count(i) = before_recall;
    before_f1_count(i) = before_f1;
    
    %Ԥ�Ⲣ����׼ȷ��
    y_Pred = classify(net1,x_test, 'SequenceLength','longest');
    [after_acc,after_precision,after_recall,after_f1]=indicator_calculation(y_test,y_Pred);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    after_acc_count(i) = after_acc;
    after_precision_count(i) = after_precision;
    after_recall_count(i) = after_recall;
    after_f1_count(i) = after_f1;
    
    %���ƻ�������
    figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
    cm = confusionchart(y_test,y_Pred);
    cm.Title = 'Confusion Matrix for Validation Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    %�����������
    confusionchartSaveDir = sprintf('%s%s%d%s%s',saveDir,'confusionchart(',i,')-',nowtimestr);
    saveas(gcf,confusionchartSaveDir);
    saveas(gcf,strcat(confusionchartSaveDir,'.jpg'));
end

result_data(2,1)=num2cell(mean(before_acc_count));%Ǩ��ǰƽ��Accuracy
result_data(2,2)=num2cell(mean(before_precision_count));%Ǩ��ǰƽ��Precision
result_data(2,3)=num2cell(mean(before_recall_count));%Ǩ��ǰƽ��Recall
result_data(2,4)=num2cell(mean(before_f1_count));%Ǩ��ǰƽ��F_score
result_data(2,5)=num2cell(mean(after_acc_count));%Ǩ�ƺ�ƽ��Accuracy
result_data(2,6)=num2cell(mean(after_precision_count));%Ǩ�ƺ�ƽ��Precision
result_data(2,7)=num2cell(mean(after_recall_count));%Ǩ�ƺ�ƽ��Recall
result_data(2,8)=num2cell(mean(after_f1_count));%Ǩ�ƺ�ƽ��F_score
result_data(2,9)=num2cell(mean(t_count.training));%Ǩ��ѧϰѵ��ƽ����ʱ

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