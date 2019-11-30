%clear;
%load('matlab.mat');
clear train_data_array train_label_array

train_data = csi_train;%x_train x_test
train_label = csi_label;%y_train y_test
input_shape = 90;

numObservations = numel(train_data);
train_data_array = zeros(numObservations,input_shape+1);
train_label_array = zeros(numObservations,1);

for n = 1:numObservations
    amplitude = train_data{n};
    m = 1;
    for k=1:input_shape
        train_data_array (n,m) =  mean(amplitude(k,:));%均值
        m = m+1;
        train_data_array (n,m) =  std(amplitude(k,:));%标准差
        m = m+1;
        %train_data_array (n,m) =  var(amplitude(k,:));%方差
        %m = m+1;
        train_data_array (n,m) =  std(amplitude(k,:))/mean(amplitude(k,:));%变异系数c.v.
        m = m+1;
    end
    %data_array (n,2*3*30*3+1) =  csi_label(n);
    train_label_array (n,1) =  train_label(n);
end

train_data_array(:,end+1)=train_label_array;
clear k m n numObservations amplitude
clear train_data train_label input_shape
%yfit = trainedModel.predictFcn(train_data_array(:,1:270));
%cm = confusionchart(train_label_array,yfit);
%[Accuracy,Precision,Recall,F_score]=indicator_calculation(train_label_array,yfit)