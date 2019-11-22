function layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses)
    switch networkType
        case 'DoubleBiLSTM'
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
                    dropoutLayer(0.5)
                    bilstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
        case 'SingleBiLSTM'
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    bilstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
        case 'DoubleLSTM'
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    lstmLayer(numHiddenUnits,'OutputMode','sequence')
                    dropoutLayer(0.5)
                    lstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
        case 'SingleLSTM'
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    lstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
        otherwise
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    bilstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
    end
end