%ѵ����������
saveDir = 'G:\��Դ��֪�о�\ʵ����\2019_11_07_ʵ����(3t3r)(1)_200unit_SingleBiLSTM_resample\';%�������·��
inputSize = 270;%����ά��
numHiddenUnits = 128;%��������
numClasses = 6;%�����ǩ��������
networkType = 'SingleBiLSTM';%ʹ�õ���������
maxEpochs = 30;%����������

Kfold = 10;%���ý����������
indices = crossvalind('Kfold',csi_label,Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);

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
    
    %ʹ��LSTMMaker��������ѵ������
    layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses);
    
    %ѵ������
    net = trainLSTM(x_train,y_train,x_test,y_test,layers,maxEpochs);
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %��������
    networkSaveDir = sprintf('%s%s%d%s%s',saveDir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %Ԥ�Ⲣ����׼ȷ��
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    acc_count(i) = acc;
    precision_count(i) = precision;
    recall_count(i) = recall;
    f1_count(i) = f1;
    
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

average_acc = mean(acc_count)
average_precision = mean(precision_count)
average_recal = mean(recall_count)
average_f1 = mean(f1_count)