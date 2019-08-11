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
        data_array (n,m) =  mean(amplitude(k,:));%��ֵ
        m = m+1;
        data_array (n,m) =  std(amplitude(k,:));%��׼��
        m = m+1;
        data_array (n,m) =  var(amplitude(k,:));%����
        m = m+1;
        data_array (n,m) =  std(amplitude(k,:))/mean(amplitude(k,:));%����ϵ��c.v.
        m = m+1;
    end
    data_array (n,91) =  YTrain(n);
end