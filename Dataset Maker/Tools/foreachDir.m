function name = foreachDir(mainPath)
    % 遍历文件夹及文件
    %   mainPath 主路径
    %   name 满足条件的文件名

    % 当前目录下的文件
    files = dir(mainPath);
    % 文件数量
    len = length(files);

    name = {};
    index = 1;
    for ii = 1 : len
        % 跳过.以及..文件夹
        if (strcmp(files(ii).name, '.') == 1) ...
                || (strcmp(files(ii).name, '..') == 1)
            continue;
        end

        % 递归调用函数，遍历当前目录下的文件夹(深度过深，可能会报错)
        if files(ii).isdir == 1
            tmpName = foreachDir(fullfile(mainPath, '\', files(ii).name));
            for kk = 1 : length(tmpName)
                name{index} = tmpName(kk);
                index = index + 1;
            end
        end

        % 读取指定类型的文件(可根据自己需要修改)
        if ~isempty(strfind(files(ii).name, '.jpg')) ...
                || ~isempty(strfind(files(ii).name, '.png')) ...
                || ~isempty(strfind(files(ii).name, '.bmp'))
            name{index} = fullfile(mainPath, '\', files(ii).name);
            index = index + 1;
        end
    end

end