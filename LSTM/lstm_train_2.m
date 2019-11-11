%训练参数设置
saveDir = 'G:\无源感知研究\实验结果\2019_11_07_实验室(3t3r)(1)_200unit_SingleBiLSTM_resample\';%结果保存路径
inputSize = 270;%输入维度
numHiddenUnits = 128;%隐层数量
numClasses = 6;%输入标签种类数量
networkType = 'SingleBiLSTM';%使用的网络类型
maxEpochs = 30;%最大迭代次数

Kfold = 10;%设置交叉检验折数
indices = crossvalind('Kfold',csi_label,Kfold);%划分训练集和测试集
%[x_train, y_train,  x_test, y_test] = split_train_test(csi_train, csi_label, 6, 0.7);

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
    
    %使用LSTMMaker函数建立训练网络
    layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses);
    
    %训练网络
    net = trainLSTM(x_train,y_train,x_test,y_test,layers,maxEpochs);
    
    %时间戳
    nowtime = fix(clock);
    nowtimestr = sprintf('%d-%d-%d-%d-%d-%d',nowtime(1),nowtime(2),nowtime(3),nowtime(4),nowtime(5),nowtime(6));
    
    %保存网络
    networkSaveDir = sprintf('%s%s%d%s%s',saveDir,'network(',i,')-',nowtimestr);
    save(networkSaveDir,'net');
    
    %预测并计算准确率
    y_Pred = classify(net,x_test, 'SequenceLength','longest');
    [acc,precision,recall,f1]=indicator_calculation(y_test,y_Pred);
    %acc = sum(y_Pred == y_test)./numel(y_test)
    acc_count(i) = acc;
    precision_count(i) = precision;
    recall_count(i) = recall;
    f1_count(i) = f1;
    
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

average_acc = mean(acc_count)
average_precision = mean(precision_count)
average_recal = mean(recall_count)
average_f1 = mean(f1_count)