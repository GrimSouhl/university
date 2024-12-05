function [x,y]=posicioncelda(x1,y1,xcelda,ycelda,indx,indy)
% Devuelve la posición del centro de la celda INDX,INDY de un grid en el 
% que la primera tiene coordenadas centrales
% X1,Y1 y la anchura de las celdas en cada eje es XCELDA,YCELDA

    x=(indx-1)*xcelda+x1;
    y=(indy-1)*ycelda+y1;
    
end
