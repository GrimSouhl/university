%{
La funcion CheckPattern(Data,W) tiene como parametros de entrada el conjunto de datos “Data” y los
pesos sinapticos de la red “W” y devuelve un booleano que es True cuando todos los datos han sido ´
clasificados de forma correcta y False si algun dato del conjunto no est ´ a bien clasificado
%}

function res = CheckPattern(Data,W)
    res=true;
    c=size(Data(1:end,1));
    for i=1:c 
    [Input,Output,Target] = ValoresIOT(Data,W,i);
    if(Output~=Target)
        res=false;
    end
    end
end

    