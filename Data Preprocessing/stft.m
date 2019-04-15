%[Au, Fs]=audioread('C:\Users\CDQ\Desktop\output.mp3');   % Fs 采样率 44100
Fs=100;
Au = amplitudeA(2500:3000,1);
[B, F, T, P] = spectrogram(Au,32,16,32,Fs);   % B是F大小行T大小列的频率峰值，P是对应的能量谱密度
figure
imagesc(T,F,C);
set(gca,'YDir','normal')
colorbar;
xlabel('时间 t/s');
ylabel('频率 f/Hz');
title('短时傅里叶时频图');