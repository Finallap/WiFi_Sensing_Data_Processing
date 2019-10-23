function layers = LSTMMaker(networkType, inputSize, numHiddenUnits, numClasses)
    switch networkType
        case 'DoubleBiLSTM'
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
                    dropoutLayer(0.2)
                    bilstmLayer(numHiddenUnits,'OutputMode','last')
                    dropoutLayer(0.2)
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
        otherwise
            layers = [ ...
                    sequenceInputLayer(inputSize)
                    bilstmLayer(numHiddenUnits,'OutputMode','last')
                    fullyConnectedLayer(numClasses)
                    softmaxLayer
                    classificationLayer];
    end
end