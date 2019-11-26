%load('G:\无源感知研究\数据采集\2019_07_18\实验室(3t3r).mat');

amplitude=csi_train{23, 1}(:,1);
sampling_rate = 100;
t = (1:length(amplitude))/sampling_rate;
time_length = length(amplitude)/sampling_rate;

figure('color',[1 1 1])
plot(t,amplitude,'k')
set(gca,'XLim',[0 time_length])
legend('original signal')
xlabel('Time(Seconds)')
ylabel('CSI amplitude')

%figure('color',[1 1 1])
%hampel(amplitude)

figure('color',[1 1 1])
[amplitude_hampel,outliers] = hampel(amplitude);
plot(t,amplitude,'r')
hold on
plot(t,amplitude_hampel,'k')
len_array=1:length(amplitude);
len_array=len_array';
plot(len_array(outliers)/sampling_rate,amplitude(outliers),'s')
hold off
set(gca,'XLim',[0 time_length])
legend('abnormal original signal','hampel filtered signal','outliers')
xlabel('Time(Seconds)')
ylabel('CSI amplitude')

figure('color',[1 1 1])
plot(t,wifi_butterworth_function(amplitude_hampel'),'k')
set(gca,'XLim',[0 time_length])
legend('butterworth filtered signal')
xlabel('Time(Seconds)')
ylabel('CSI amplitude')