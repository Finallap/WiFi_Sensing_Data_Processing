sequence = amplitude(61:90,:);

%画原始波形
figure
plot(sequence','DisplayName','amplitude')

%时域相关系数计算和画图
corr_time = corrcoef(sequence);
med_time=median(corr_time);
figure
imagesc(corr_time)
figure
plot(med_time)

%频域相关系数计算和画图
corr_frequency = corrcoef(sequence');
med_frequency=median(corr_frequency);
figure
imagesc(corr_frequency)
figure
plot(med_frequency)

%MI = med_time * exp(0.1 * med_frequency)
MI = med_time .* exp(0.1 * median(med_frequency));
figure
plot(MI)