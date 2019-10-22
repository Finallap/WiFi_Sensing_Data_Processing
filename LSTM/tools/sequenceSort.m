function [x_train,y_train] = sequenceSort(x_train,y_train)
    numObservations = numel(x_train);
    for i=1:numObservations
        sequence = x_train{i};
        sequenceLengths(i) = size(sequence,2);
    end

    [~,idx] = sort(sequenceLengths);
    x_train = x_train(idx);
    y_train = y_train(idx);
end