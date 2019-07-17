function fileNames = traversing_folder(dirPath,fileExtension)
fileFolder=fullfile(dirPath);
dirOutput=dir(fullfile(fileFolder,fileExtension));
fileNames={dirOutput.name};
end