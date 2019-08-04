%clear;
%load('04_28_csi_dataset.mat');
[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);%划分训练集和测试集

numObservations = numel(x_train);
for i=1:numObservations
    sequence = x_train{i};
    sequenceLengths(i) = size(sequence,2);
end

[sequenceLengths,idx] = sort(sequenceLengths);
x_train = x_train(idx);
y_train = y_train(idx);

inputSize = 180;
numHiddenUnits = 128;
numClasses = 6;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(100,'OutputMode','sequence')
    dropoutLayer(0.2)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    dropoutLayer(0.2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 750;
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
    'LearnRateDropPeriod', 20, ...
    'L2Regularization',0.0004,...
    'Plots','training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_Pred = classify(net,x_test, ...
    'SequenceLength','longest');

acc = sum(y_Pred == y_test)./numel(y_test)
 
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(y_test,y_Pred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';