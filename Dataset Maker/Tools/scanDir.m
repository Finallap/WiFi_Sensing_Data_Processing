function [fullPaths,names,dirs] = scanDir(root_dir)

fullPaths={};
names={};
dirs={};
if root_dir(end)~=filesep
 root_dir=[root_dir,filesep];
end
fileList=dir(root_dir);  %扩展名
n=length(fileList);
cntpic=0;
for i=1:n
    if strcmp(fileList(i).name,'.')==1||strcmp(fileList(i).name,'..')==1
        continue;
    else
        %fileList(i).name
        if ~fileList(i).isdir % 如果不是目录则跳过
            
            full_path=[root_dir,fileList(i).name];
            file_name=fileList(i).name;
            
                 cntpic=cntpic+1;
                 fullPaths(cntpic)={full_path};
                 names(cntpic)={file_name};
                 dirs(cntpic)={root_dir};
%              end
        else
            [fullPaths_temp,names_temp,dir_temp] = scanDir([root_dir,fileList(i).name]);
            fullPaths=[fullPaths,fullPaths_temp];
            names=[names,names_temp];
            dirs=[dirs,dir_temp];
        end
    end
end

end