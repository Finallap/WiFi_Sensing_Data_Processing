function [acc_count,precision_count,recall_count,f1_count,t_count] = trainAndEvaluation(csi_train,csi_label,job_options)
indices = crossvalind('Kfold',csi_label,job_options.Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);

%Ԥ�������洢����
acc_count = zeros(job_options.Kfold,1);
precision_count = zeros(job_options.Kfold,1);
recall_count = zeros(job_options.Kfold,1);
f1_count = zeros(job_options.Kfold,1);

for i = 1:job_options.Kfold
    tic;%Ԥ����ʼ��ʱ
    %���ִ˴ε�ѵ�����Ͳ��Լ�
    test = (indices == i); 
    train = ~test;
    x_train = csi_train(train);
    y_train = csi_label(train);
    x_test = csi_train(test);
    y_test = csi_label(test);
    
    %��ѵ������������
    [x_train,y_train] = sequenceSort(x_train,y_train);
    t_count.preprocessed(i) = toc;%Ԥ���������ʱ
    
    %ʹ��LSTMMaker��������ѵ������
    tic;%ѵ����ʼ��ʱ
    layers = LSTMMaker(job_options.networkType, job_options.inputSize, job_options.numHiddenUnits, job_options.numClasses);
    
    %ѵ������
    net = trainLSTM(x_train,y_train,x_test,y_test,layers,job_options.maxEpochs);
    t_count.training(i) = toc;%ѵ��������ʱ
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %��������
    networkSaveDir = sprintf('%s%s%d%s%s',job_options.result_save_dir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %Ԥ�Ⲣ����׼ȷ��
    tic;%Ԥ�⿪ʼ��ʱ
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [acc,precision,recall,f1]=indicator_calculation(y_Pred,y_test);
    acc_count(i) = acc;
    precision_count(i) = precision;
    recall_count(i) = recall;
    f1_count(i) = f1;
    t_count.prediction(i) = toc;%Ԥ�������ʱ
    
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