Kfold = 10;%���ý����������
indices = crossvalind('Kfold',csi_label,Kfold);%����ѵ�����Ͳ��Լ�
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);
saveDir = 'G:\��Դ��֪�о�\ʵ����\2019_08_21_Ǩ��ѧϰ�����㣩\������ to ʵ���� 1\';

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
    net1 = trainLSTM(x_train,y_train,x_test,y_test,layers_1);
    
    %ʱ���
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %����Ǩ��ǰ׼ȷ��
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    acc = sum(y_Pred == y_test)./numel(y_test)
    before_acc_count(i) = acc;
    
    %Ԥ�Ⲣ����׼ȷ��
    y_Pred = classify(net1,x_test, 'SequenceLength','longest');
    acc = sum(y_Pred == y_test)./numel(y_test)
    after_acc_count(i) = acc;
    
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
maxEpochs = 75;
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
        'InitialLearnRate',1e-4, ...
        'Plots','training-progress');
    
net = trainNetwork(x_train,y_train,layers_1,options);
end