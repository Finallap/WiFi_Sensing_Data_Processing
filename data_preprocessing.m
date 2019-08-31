fs=100;%采样频率
wp=1.5;         %通带截止频率
ws=4;         %阻带截止频率
rp=1;               %通带最大衰减
as=80;              %阻带最小衰减

%进行巴特沃斯滤波
amplitude = wifi_butterworth(amplitudeB2,fs,wp,ws,rp,as);
%amplitude = amplitudeB2;

%进行PCA降维
[coeff,score,latent] = pca(amplitude);
first_pca = score(:,1);
second_pca = score(:,2);

%中值滤波
%sequence = medfilt1(first_pca,20);