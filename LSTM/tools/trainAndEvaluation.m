function [acc_count] = trainAndEvaluation(job_options)
indices = crossvalind('Kfold',csi_label,job_options.Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);

for i = 1:job_options.Kfold
    %���ִ˴ε�ѵ�����Ͳ��Լ�
    test = (indices == i); 
    train = ~test;
    x_train = csi_train(train);
    y_train = csi_label(train);
    x_test = csi_train(test);
    y_test = csi_label(test);
    
    %��ѵ������������
    [x_train,y_train] = sequenceSort(x_train,y_train);
    
    %ʹ��LSTMMaker��������ѵ������
    layers = LSTMMaker(job_options.networkType, job_options.inputSize, job_options.numHiddenUnits, job_options.numClasses);
    
    %ѵ������
    net = trainLSTM(x_train,y_train,x_test,y_test,layers,job_options.maxEpochs);
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %��������
    networkSaveDir = sprintf('%s%s%d%s%s',job_options.result_save_dir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %Ԥ�Ⲣ����׼ȷ��
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    acc = sum(y_Pred == y_test)./numel(y_test);
    acc_count(i) = acc;
    
    %���ƻ�������
    figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
    cm = confusionchart(y_test,y_Pred);
    cm.Title = 'Confusion Matrix for Validation Data';
    cm.ColumnSummary = 'column-normalized';
    cm.RowSummary = 'row-normalized';
    
    %�����������
    confusionchartSaveDir = sprintf('%s%s%d%s%s',job_options.result_save_dir,'confusionchart(',i,')-',nowtimestr);
    saveas(gcf,confusionchartSaveDir);
    saveas(gcf,strcat(confusionchartSaveDir,'.jpg'));
end