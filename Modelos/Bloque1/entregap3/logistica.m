function [Y] = logistica(X,beta)
%% Calcula la función logística para cada uno de los elementos del vector columna X
    Y= 1./(1.+exp(-2*beta.*X));
end

