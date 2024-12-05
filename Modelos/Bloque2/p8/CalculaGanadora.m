function [Gx,Gy] = CalculaGanadora(w,Patron)

Gx=1;
Gy=1;
distOpt = inf;
[numAH,numFil,numCol]=size(w)

for i=1:1:numFil
      for j=1:1:numCol
          dist=norm(w(:,i,j)-Patron,2);
          if dist<distOp
              Gx=i;
              Gy=j;
              distOp=dist;
          end
      end
end
