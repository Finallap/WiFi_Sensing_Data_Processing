dir_path = 'C:\Users\Finallap\Desktop\新建文件夹\';
value_index = 1;
file_name_index = 1;

for i = 1:length(csi_train)
    file_name = strcat(dir_path,csi_label{i,file_name_index},".csv");
    value_matrix = csi_train{i,value_index};

    %csvwrite不会产生表头
    csvwrite(file_name,value_matrix);
    
    %writetable方式也可以用，但是会有表头
    %result_table=table(value_matrix);
    %writetable(result_table, file_name);
end