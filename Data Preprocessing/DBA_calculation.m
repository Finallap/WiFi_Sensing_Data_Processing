function dba_result = DBA_calculation(path)
    load(path);
    sample_num = size(csi_train,1);

    for i=1:sample_num
        csi_train{i,1}=csi_train{i,1}';
    end

    dba_result = DBA(csi_train);
end