fs=100;%����Ƶ��
wp=5;         %ͨ����ֹƵ��
ws=8;         %�����ֹƵ��
rp=1;               %ͨ�����˥��
as=60;              %�����С˥��

%���а�����˹�˲�
amplitude = wifi_butterworth(amplitudeB2,fs,wp,ws,rp,as);
%amplitude = amplitudeB2;

%����PCA��ά
[coeff,score,latent] = pca(amplitude);
first_pca = score(:,1);
second_pca = score(:,2);

%��ֵ�˲�
%sequence = medfilt1(first_pca,20);