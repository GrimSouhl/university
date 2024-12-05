function W = UpdateNet(W,LR,Output,Target,Input)
    difW = LR*(Target-Output)*[Input-1]';
    W = W + difW;
end