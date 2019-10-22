function layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses)
    if(strcmp(networkType,'DoubleBiLSTM'))
        layers = [ ...
                sequenceInputLayer(inputSize)
                bilstmLayer(numHiddenUnits,'OutputMode','sequence')
                dropoutLayer(0.2)
                bilstmLayer(numHiddenUnits,'OutputMode','last')
                dropoutLayer(0.2)
                fullyConnectedLayer(numClasses)
                softmaxLayer
                classificationLayer];
    elseif(strcmp(networkType,'SingleBiLSTM'))
        layers = [ ...
                sequenceInputLayer(inputSize)
                bilstmLayer(numHiddenUnits,'OutputMode','last')
                fullyConnectedLayer(numClasses)
                softmaxLayer
                classificationLayer];
    else
        layers = [ ...
                sequenceInputLayer(inputSize)
                bilstmLayer(numHiddenUnits,'OutputMode','last')
                fullyConnectedLayer(numClasses)
                softmaxLayer
                classificationLayer];
    end
end