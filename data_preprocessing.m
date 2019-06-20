fs=100;%采样频率
wp=5;         %通带截止频率
ws=10;         %阻带截止频率

%进行巴特沃斯滤波
amplitude = wifi_butterworth(amplitudeB2,fs,wp,ws);
%amplitude = amplitudeB2;

%进行PCA降维
[coeff,score,latent] = pca(amplitude);
first_pca = score(:,1);
second_pca = score(:,2);

%中值滤波
%sequence = medfilt1(first_pca,20);