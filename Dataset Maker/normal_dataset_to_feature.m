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
    for k=1:180
        data_array (n,m) =  mean(amplitude(k,:));%��ֵ
        m = m+1;
        data_array (n,m) =  std(amplitude(k,:));%��׼��
        m = m+1;
        %data_array (n,m) =  var(amplitude(k,:));%����
        %m = m+1;
        data_array (n,m) =  std(amplitude(k,:))/mean(amplitude(k,:));%����ϵ��c.v.
        m = m+1;
    end
    %data_array (n,2*3*30*3+1) =  csi_label(n);
    data_array1 (n,1) =  csi_label(n);
end