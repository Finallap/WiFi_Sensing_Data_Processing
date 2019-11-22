dirPath = 'G:\无源感知研究\数据采集\Cross Scene(201911)\Scene1(lab)';
resultSavePath = 'G:\无源感知研究\数据采集\Cross Scene(201911)\Scene1(lab)(plot)';
fileNames = traversing_folder(dirPath,'*.dat');

sceneNames = ["Laboratory","To be determined"];
positionNames = ["Center","Left side","Right side"];
orientedNames = ["Facing the RX","Facing the TX","Parallel to the link"];
volunteerNames = ["V1","V2","V3","V4","V5","V6"];
actionNames = ["Jump","Pick","Throw","Pull","Clap","Box","Wave", ...
    "Lift","Kick","Squat","Turn round","Check watch"];

csi_train = cell(length(fileNames),3);
csi_label = cell(length(fileNames),6);

amplitude_std = zeros(length(fileNames),3);

%循环遍历整个文件夹
for i=1:length(fileNames)
    fileNameSplit = strsplit(fileNames{1,i},'.');
    fileName = fileNameSplit{1};
    
    %读取CSI及RSSI信息
    [amplitude,phase,rssi] = csi_reading_1t3r(strcat(dirPath,'\',fileName,'.dat'));
    
    disp([fileName,' read completed']);
    
    csi_train{i,1} = amplitude;
    csi_train{i,2} = phase;
    csi_train{i,3} = rssi;
    
    labelSplit = strsplit(fileName,'-');
    csi_label{i,1} = char(sceneNames(str2num(labelSplit{1, 1}(2:end))));
    csi_label{i,2} = char(positionNames(str2num(labelSplit{1, 2}(2:end))));
    csi_label{i,3} = char(orientedNames(str2num(labelSplit{1, 3}(2:end))));
    csi_label{i,4} = char(volunteerNames(str2num(labelSplit{1, 4}(2:end))));
    csi_label{i,5} = char(actionNames(str2num(labelSplit{1, 5}(2:end))));
    csi_label{i,6} = str2num(labelSplit{1, 6}(2:end));
    
%     amplitude = amplitude';
%     amplitude = hampel(amplitude);
%     [~,amplitude_pcaA] = pca(amplitude(:,1:30));
%     [~,amplitude_pcaB] = pca(amplitude(:,31:60));
%     [~,amplitude_pcaC] = pca(amplitude(:,61:90));
%     
%     amplitude_std(i,1) = std(amplitude_pcaA(:,1));
%     amplitude_std(i,2) = std(amplitude_pcaB(:,1));
%     amplitude_std(i,3) = std(amplitude_pcaC(:,1));
%     
%     R = corrcoef(amplitude);
%     
%     subplot(3,1,1);
%     plot(amplitude(:,1:30),'DisplayName','amplitudeA');
%     title(fileName);
%     subplot(3,1,2);
%     plot(amplitude(:,31:60),'DisplayName','amplitudeB');
%     subplot(3,1,3);
%     plot(amplitude(:,61:90),'DisplayName','amplitudeC');
%     pcaResultStr = sprintf('%s%f%s%f%s%f','amplitudeA Std=',amplitude_std(i,1), ...
%     ',amplitudeB Std=',amplitude_std(i,2),',amplitudeC Std=',amplitude_std(i,3));
%     xlabel(pcaResultStr);
%     saveas(gcf,strcat(resultSavePath,'\',fileName,'.jpg'));
end