function [Y] = derivadaLogistica(X,beta)
    Y= (2* beta).*logistica(X,beta).*(1.-logistica(X,beta));
end

