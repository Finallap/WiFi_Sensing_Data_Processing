function [Accuracy,Precision,Recall,F_score]=indicator_calculation(output,target)
    %% accuracy
    Accuracy = sum(output == target)./numel(y_test);

    %% matrice confusion
    [confMat,~] = confusionmat(output,target);

    %% recall
    for i =1:size(confMat,1)
        recall(i)=confMat(i,i)/sum(confMat(i,:));
    end
    recall(isnan(recall))=[];
    Recall=sum(recall)/size(confMat,1);

    %% precision
    for i =1:size(confMat,1)
        precision(i)=confMat(i,i)/sum(confMat(:,i));
    end
    Precision=sum(precision)/size(confMat,1);

    %% F-score
    F_score=2*Recall*Precision/(Precision+Recall); 
    %%F_score=2*1/((1/Precision)+(1/Recall));
end