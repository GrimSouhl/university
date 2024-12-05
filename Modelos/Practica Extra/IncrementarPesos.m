function w = IncrementarPesos(w,patron,vecindad,eta)
[numAt,numFil,numCol]=size(w);
for i=1:1:numFil
    for j=1:1:numCol
        %%tenemos que cambiar w en el espacio de entrada en el espacio
        %%topologico no se cambia nunco
        w(:,i,j)= w(:,i,j)+(eta*vecindad(i,j)(patron-w(:,i,j)));
    end
end
