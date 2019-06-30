clear;
load('04_28_csi_dataset.mat');
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
numHiddenUnits = 100;
numClasses = 6;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 800;
miniBatchSize = 27;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(x_train,y_train,layers,options);

miniBatchSize = 27;
y_Pred = classify(net,x_test, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(y_Pred == y_test)./numel(y_test)
 
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(y_test,y_Pred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';