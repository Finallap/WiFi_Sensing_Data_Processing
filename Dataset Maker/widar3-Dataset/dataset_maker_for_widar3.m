dirPath = '/home/shengby/Datasets/Widar3_original_old/20181205/user3/';
resultSavePath = '/home/shengby/Datasets/CSI_mat/Widar3_original/20181205_user3.mat';
%[fileNames,filePaths] = traversing_folder(dirPath,'*.dat');
[filePaths,fileNames,fileDirs] = scanDir(dirPath);

%actionNames = ["Push&Pull","Sweep","Clap","Slide","Draw-Zigzag(Vertical)","Draw-N(Vertical)"];
%actionNames = ["Draw-1","Draw-2","Draw-3","Draw-4","Draw-5","Draw-6","Draw-7","Draw-8","Draw-9","Draw-0"];
%actionNames = ["Slide","Draw-O(Horizontal)","Draw-Zigzag(Horizontal)","Draw-N(Horizontal)","Draw-Tiangle(Horizontal)","Draw-Rectangle(Horizontal)"];
%actionNames = ["Push&Pull","Sweep","Clap","Slide","Draw-O(Horizontal)","Draw-Zigzag(Horizontal)","Draw-N(Horizontal)","Draw-Tiangle(Horizontal)","Draw-Rectangle(Horizontal)"];
%actionNames = ["Push&Pull","Sweep","Clap","Slide","Draw-O(Horizontal)","Draw-Zigzag(Horizontal)"];
%actionNames = ["Push&Pull","Sweep","Clap","Slide"];
actionNames = ["Slide","Draw-O(Horizontal)","Draw-Zigzag(Horizontal","Draw-N(Horizontal)","Draw-Tiangle(Horizontal)","Draw-Rectangle(Horizontal)"];

csi_train = cell(fix(length(fileNames)/6),1);
csi_label = cell(fix(length(fileNames)/6),5);

%循环遍历整个文件夹
for i=1:6:length(fileNames)
    fileDir = fileDirs{1,i};
    fileNameSplit = strsplit(fileNames{1,i},'.');
    fileName = fileNameSplit{1};
    
    %读取CSI信息
    [amplitude1,~,~] = csi_reading_1t3r(strcat(fileDir,fileName(1:end-1),'1','.dat'));
    [amplitude2,~,~] = csi_reading_1t3r(strcat(fileDir,fileName(1:end-1),'2','.dat'));
    [amplitude3,~,~] = csi_reading_1t3r(strcat(fileDir,fileName(1:end-1),'3','.dat'));
    final_length = max([size(amplitude1,1),size(amplitude2,1),size(amplitude3,1)]);
    amplitude1 = resample(amplitude1,final_length,size(amplitude1,1));
    amplitude2 = resample(amplitude2,final_length,size(amplitude2,1));
    amplitude3 = resample(amplitude3,final_length,size(amplitude3,1));
    amplitude = cat(2,amplitude1,amplitude2,amplitude3);
    
    disp([fileName,' read completed']);
    
    if i == 1
        num = 1;
    else
        num = fix(i/6)+1;
    end
    
    csi_train{num,1} = amplitude;
    %csi_train{num,2} = phase;
    %csi_train{num,3} = rssi;
    
    labelSplit = strsplit(fileName,'-');
    csi_label{num,1} = char(labelSplit{1, 1});
    csi_label{num,2} = char(actionNames(str2num(labelSplit{1, 2})));
    csi_label{num,3} = str2num(labelSplit{1, 3});
    csi_label{num,4} = str2num(labelSplit{1, 4});
    csi_label{num,5} = str2num(labelSplit{1, 5});
end
save(resultSavePath,'csi_label','csi_train');
exit