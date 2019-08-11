clear;
load('matlab.mat');

if(exist('data_array','var')==0)
    data_array = [];
end

numObservations = numel(XTrain);

for n = 1:numObservations
    amplitude = XTrain{n};
    m = 1;
    for k=1:30
        data_array (n,m) =  mean(amplitude(k,:));%均值
        m = m+1;
        data_array (n,m) =  std(amplitude(k,:));%标准差
        m = m+1;
        data_array (n,m) =  var(amplitude(k,:));%方差
        m = m+1;
        data_array (n,m) =  std(amplitude(k,:))/mean(amplitude(k,:));%变异系数c.v.
        m = m+1;
    end
    data_array (n,91) =  YTrain(n);
end