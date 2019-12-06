%clear;
%load('04_28_csi_dataset.mat');

%参数配置
sample_count = size(csi_train,1);
inputSize = size(csi_train{1,1},1);
sequence_len = size(csi_train{1,1},2);
numClasses = size(categories(csi_label),1);
maxEpochs = 200;
miniBatchSize = 64;

%划分训练集和测试集
[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, numClasses, 0.7);

x_train_array = zeros(inputSize/3,sequence_len,3,size(x_train,1));
for i = 1:size(x_train,1)
    x_train_array(:,:,1,i) = x_train{i,1}(1:90,:);
	x_train_array(:,:,1,i) = x_train{i,1}(91:180,:);
    x_train_array(:,:,1,i) = x_train{i,1}(181:270,:);
%     x_train_array(:,:,1,i) = x_train{i,1}(1:30,:);
% 	x_train_array(:,:,1,i) = x_train{i,1}(31:60,:);
%     x_train_array(:,:,1,i) = x_train{i,1}(61:90,:);
end

x_test_array = zeros(inputSize/3,sequence_len,3,size(x_test,1));
for i = 1:size(x_test,1)
    x_test_array(:,:,1,i) = x_test{i,1}(1:90,:);
	x_test_array(:,:,1,i) = x_test{i,1}(91:180,:);
    x_test_array(:,:,1,i) = x_test{i,1}(181:270,:);
%     x_test_array(:,:,1,i) = x_test{i,1}(1:30,:);
% 	x_test_array(:,:,1,i) = x_test{i,1}(31:60,:);
%     x_test_array(:,:,1,i) = x_test{i,1}(61:90,:);
end

%建立训练网络
layers = [
    imageInputLayer([inputSize/3 sequence_len 3])

    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)
  
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    dropoutLayer(0.2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

filterSize = [5 5];
numFilters = 32;

layers_1 = [
    imageInputLayer([inputSize/3 sequence_len 3])
    
    convolution2dLayer(filterSize, numFilters, 'Padding', 2)
    reluLayer()
    maxPooling2dLayer(3, 'Stride', 2)
    
    convolution2dLayer(filterSize, numFilters, 'Padding', 2)
    reluLayer()
    maxPooling2dLayer(3, 'Stride',2)
 
    convolution2dLayer(filterSize, 2 * numFilters, 'Padding', 2)
    reluLayer()
    maxPooling2dLayer(3, 'Stride',2)
    
    reluLayer
    
    dropoutLayer(0.2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'SequenceLength','longest', ...
    'Verbose',0, ...
    'ValidationData',{x_test_array,y_test}, ...
    'ValidationFrequency',10, ...
    'LearnRateSchedule', 'piecewise', ...
    'L2Regularization',0.0004,...
    'Plots','training-progress');

net = trainNetwork(x_train_array,y_train,layers_1,options);

y_Pred = classify(net,x_test_array, ...
    'SequenceLength','longest');

[acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred)
 
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(y_test,y_Pred);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';