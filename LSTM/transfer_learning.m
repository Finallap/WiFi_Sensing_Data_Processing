[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);%划分训练集和测试集

numObservations = numel(x_train);
for i=1:numObservations
    sequence = x_train{i};
    sequenceLengths(i) = size(sequence,2);
end

[sequenceLengths,idx] = sort(sequenceLengths);
x_train = x_train(idx);
y_train = y_train(idx);

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
        'InitialLearnRate',1e-3, ...%搭配100倍率的fc lr提升
        'Plots','training-progress');
    
net1 = trainNetwork(x_train,y_train,layers_1,options);

y_Pred = classify(net1,x_test, ...
    'SequenceLength','longest');

[acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred)
 
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(y_test,y_Pred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
cm.Normalization = 'row-normalized';