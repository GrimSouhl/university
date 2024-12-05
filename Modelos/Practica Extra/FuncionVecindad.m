function Vecindad= FuncionVecindad(IndGan, w , indices)
[numAt,numFil,numCol]=size(w);
Vecindad=zeros(numFil,numCol);
for i=1:1:numFil
    for j=1:1:numCol
        if(InfGan(1)==i && InGan(2)==j)
            Vecindad(i,j)=1;
        else 
            if(sum(abs(IndGan-indices(:,i,j)))==1)%%Para hacerla competitiva eliminamos este if para que la ganadora sea 1 y las demás 0
                Vecindad(i,j)=0.15; %%en el punto tres seria cambiar el 0.15 por el valor de la funcion
                %%Λ(pi, pj) = exp(−||pi − pj||2) 
            end
        end
    end
end