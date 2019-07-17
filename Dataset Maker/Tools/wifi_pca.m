function pca_sequence=wifi_pca(amplitude)
    L=length(amplitude);
    pca_sequence=zeros(12,L);
    for steam_start_nums = 1:30:180
        [coeff,score] = pca(amplitude(steam_start_nums : steam_start_nums+29 , :)');
        pca_num = (steam_start_nums-1)/30 + 1;
        pca_sequence(pca_num,:) = score(:,1)';%放入第一主成分
        pca_sequence(pca_num + 6 ,:)  = score(:,2)';%放入第二主成分
    end
end