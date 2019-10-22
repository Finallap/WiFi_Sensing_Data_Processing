Kfold = 10;%设置交叉检验折数
indices = crossvalind('Kfold',csi_label,Kfold);%划分训练集和测试集
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);
saveDir = 'G:\无源感知研究\实验结果\2019_10_22_会议室（3t3r1)（双层）（归一化）\';

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
    net = trainLSTM(x_train,y_train,x_test,y_test);
    
    %时间戳
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %保存网络
    networkSaveDir = sprintf('%s%s%d%s%s',saveDir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %预测并计算准确率
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    acc = sum(y_Pred == y_test)./numel(y_test)
    acc_count(i) = acc;
    
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

function net = trainLSTM(x_train,y_train,x_test,y_test)
    train_data_size = size(x_train{1,1});
    inputSize = train_data_size(1);
    numHiddenUnits = 128;
    numClasses = 6;
	networkType = 'DoubleBiLSTM';

    %使用LSTMMaker函数建立训练网络
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