
N= 8;
Theta= zeros(N,N); 
Theta(:,:)= -1;
%%2N->tablero 3ºN-> con quien está conectado
w= zeros(N,N,N,N);%%2PRIMERAS DONDE INICIA 2 SEGUNDAS HACIA DONDE VA

for i=1:1:N
    for j=1:1:N
        w(i,j,1:N,j)=-2;
        w(i,j,i,1:N)= -2;
        w(i,j,i,j)= 0;
    end
end

epoc =200;
Shist= zeros(N,N, epoc);
%%---epoc-------------
for e=2:1:epoc 
    cambio=false;
    Shist(:,:,e)=Shist(:,:,e-1);
    %%------i-----j--------
    for i=1:1:N
        for j=1:1:N
            h=0;
            %%%----l---------k---------
            for l=1:1:N
                for k=1:1:N
                    h=h+ Shist(l,k,e)*w(i,j,l,k); %%-----l,k con el que esta conectado
                end %%end for k-------------------
            end %%end for l-----------------------
            Shist(i,j,e)=int16(h>Theta(i,j));
            
        end%%end for j----------------------
     
    end%end for i---------------------------
    if(Shist(:,:,e)==Shist(:,:,e-1))
                cambio=true;
                break;
    end %%end if
end%%end for epoc---------------------------
