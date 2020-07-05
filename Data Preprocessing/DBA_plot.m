startNum = 21;
endNum = 25;
num = 1;
for i=startNum:endNum
    x{num,1}=csi_train1{i,1};
    num = num+1;
end

dba_result = DBA(x);
subplot(3,2,1);
plot(dba_result);
title("DBA processed sequence");

num = 2;
for i=startNum:endNum
    subplot(3,2,num);
    plot(csi_train1{i, 1});
    title(strcat("Original sequence #",num2str(num-1)));
    num = num+1;
end