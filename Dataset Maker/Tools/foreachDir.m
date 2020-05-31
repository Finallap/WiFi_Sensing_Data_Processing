function name = foreachDir(mainPath)
    % �����ļ��м��ļ�
    %   mainPath ��·��
    %   name �����������ļ���

    % ��ǰĿ¼�µ��ļ�
    files = dir(mainPath);
    % �ļ�����
    len = length(files);

    name = {};
    index = 1;
    for ii = 1 : len
        % ����.�Լ�..�ļ���
        if (strcmp(files(ii).name, '.') == 1) ...
                || (strcmp(files(ii).name, '..') == 1)
            continue;
        end

        % �ݹ���ú�����������ǰĿ¼�µ��ļ���(��ȹ�����ܻᱨ��)
        if files(ii).isdir == 1
            tmpName = foreachDir(fullfile(mainPath, '\', files(ii).name));
            for kk = 1 : length(tmpName)
                name{index} = tmpName(kk);
                index = index + 1;
            end
        end

        % ��ȡָ�����͵��ļ�(�ɸ����Լ���Ҫ�޸�)
        if ~isempty(strfind(files(ii).name, '.jpg')) ...
                || ~isempty(strfind(files(ii).name, '.png')) ...
                || ~isempty(strfind(files(ii).name, '.bmp'))
            name{index} = fullfile(mainPath, '\', files(ii).name);
            index = index + 1;
        end
    end

end