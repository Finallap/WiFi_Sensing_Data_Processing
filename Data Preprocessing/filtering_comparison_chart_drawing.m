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
%save_figure(figure,'original.')

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
%save_figure(figure,'hampel.')

figure('color',[1 1 1])
plot(t,wifi_butterworth_function(amplitude_hampel'),'k')
set(gca,'XLim',[0 time_length])
legend('butterworth filtered signal')
xlabel('Time(Seconds)')
ylabel('CSI amplitude')
%save_figure(figure,'butterworth.')

function save_figure(figure,savename)
    hfig = figure;
    figWidth = 5;  % 设置图片宽度
    figHeight = 5;  % 设置图片高度
    set(hfig,'PaperUnits','inches'); % 图片尺寸所用单位
    set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
    fileout = [savename]; % 输出图片的文件名
    print(hfig,[fileout,'tif'],'-r600','-dtiff'); % 设置图片格式、分辨率
end