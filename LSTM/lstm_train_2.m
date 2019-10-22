Kfold = 10;%���ý����������
indices = crossvalind('Kfold',csi_label,Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);
saveDir = 'G:\��Դ��֪�о�\ʵ����\2019_10_22_�����ң�3t3r1)��˫�㣩����һ����\';

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
    net = trainLSTM(x_train,y_train,x_test,y_test);
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %��������
    networkSaveDir = sprintf('%s%s%d%s%s',saveDir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %Ԥ�Ⲣ����׼ȷ��
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    acc = sum(y_Pred == y_test)./numel(y_test)
    acc_count(i) = acc;
    
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

function net = trainLSTM(x_train,y_train,x_test,y_test)
    train_data_size = size(x_train{1,1});
    inputSize = train_data_size(1);
    numHiddenUnits = 128;
    numClasses = 6;
	networkType = 'DoubleBiLSTM';

    %ʹ��LSTMMaker��������ѵ������
    layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses);

    maxEpochs = 40;
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
        'LearnRateSchedule', 'piecewise', ...
    	'LearnRateDropFactor', 0.8, ...
        'LearnRateDropPeriod', 25, ...
        'Plots','training-progress');

    net = trainNetwork(x_train,y_train,layers,options);
end