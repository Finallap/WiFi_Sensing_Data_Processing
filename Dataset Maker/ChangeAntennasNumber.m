clear;
load('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\������(3t3r)(1).mat');
sample_num = size(csi_train,1);

for i=1:sample_num
    csi_train1{i, 1} = csi_train{i, 1}(:,181:270);%�����н���ת��
end
clear csi_train sample_num i
csi_train = csi_train1;
clear csi_train1
save('G:\��Դ��֪�о�\���ݲɼ�\2019_07_18\�ı���������\������(3t3r)(1)_t3')