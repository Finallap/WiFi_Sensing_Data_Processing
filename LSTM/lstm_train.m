%clear;
%load('04_28_csi_dataset.mat');

%参数配置
inputSize = size(csi_train{1,1},1);
numHiddenUnits = 200;
numClasses = size(categories(csi_label),1);
networkType = 'SingleBiLSTM';
maxEpochs = 150;
miniBatchSize = 32;

%划分训练集和测试集
[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, numClasses, 0.7);

%对训练集进行排序
[x_train,y_train] = sequenceSort(x_train,y_train);

%使用LSTMMaker函数建立训练网络
layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses);

options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Verbose',0, ...
    'ValidationData',{x_test,y_test}, ...
    'ValidationFrequency',5, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.8, ...
    'LearnRateDropPeriod', 20, ...
    'L2Regularization',0.0004,...
    'Plots','training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_Pred = classify(net,x_test, ...
    'SequenceLength','longest');

[acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred)
 
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(y_test,y_Pred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';