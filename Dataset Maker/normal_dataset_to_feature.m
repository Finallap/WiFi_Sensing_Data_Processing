%clear;
%load('matlab.mat');

if(exist('data_array','var')==0)
    data_array = [];
    data_array1 = [];
end

numObservations = numel(csi_train);

for n = 1:numObservations
    amplitude = csi_train{n};
    m = 1;
    for k=1:270
        data_array (n,m) =  mean(amplitude(k,:));%均值
        m = m+1;
        %data_array (n,m) =  std(amplitude(k,:));%标准差
        %m = m+1;
        %data_array (n,m) =  var(amplitude(k,:));%方差
        %m = m+1;
        %data_array (n,m) =  std(amplitude(k,:))/mean(amplitude(k,:));%变异系数c.v.
        %m = m+1;
    end
    %data_array (n,2*3*30*3+1) =  csi_label(n);
    data_array1 (n,1) =  csi_label(n);
end

data_array(:,end+1)=data_array1;
%yfit = trainedModel.predictFcn(data_array(:,1:540));
%cm = confusionchart(data_array1,yfit);
%[Accuracy,Precision,Recall,F_score]=indicator_calculation(yfit,data_array1)