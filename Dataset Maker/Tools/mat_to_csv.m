dir_path = 'C:\Users\Finallap\Desktop\�½��ļ���\';
value_index = 1;
file_name_index = 1;

for i = 1:length(csi_train)
    file_name = strcat(dir_path,csi_label{i,file_name_index},".csv");
    value_matrix = csi_train{i,value_index};

    %csvwrite���������ͷ
    csvwrite(file_name,value_matrix);
    
    %writetable��ʽҲ�����ã����ǻ��б�ͷ
    %result_table=table(value_matrix);
    %writetable(result_table, file_name);
end