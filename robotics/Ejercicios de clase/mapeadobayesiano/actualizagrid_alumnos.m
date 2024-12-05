function [gridk,numchs]=actualizagrid(gridk_1,l0,x1,y1,xcelda,ycelda,...
                             posek,zk,offsx,offsy,offsphi,...
                             zmax,anchobst,aperturasensor,locc,lfree)
% Actualiza el occupancy grid GRIDK_1 dado que el robot se ha movido a
% POSEK y ha tomado una observación ZK.
% L0 es el log-odds inicial: log(pm0/(1-pm0));
% X1,Y1 son las coordenadas en el plano del centro de la celda (1,1) del
% grid; XCELDA e YCELDA son los anchos de las celdas en cada eje.
% Los offset son del sónar respecto al centro de movimiento del robot.
% ZMAX (m) es la distancia máxima que puede dar el sónar
% ANCHOBST (m) es el grosor de los obstáculos del entorno
% APERTURASENSOR (radianes) es el ángulo de apertura del sensor (media
% anchura)
% LOCC es el log-odd de la probabilidad de una celda ocupada si creemos que
% puede estarlo, y LFREE lo mismo para las libres. Debería cumplirse
% LFREE<L0<LOCC

[numxs,numys]=size(gridk_1);

posesonar=calculaposesonar(posek,offsx,offsy,offsphi);

% normalizamos la pose del sonar a -pi ... pi para comparar con un atan2
while (posesonar(3)<0)
    posesonar(3)=posesonar(3)+2*pi;
end
while (posesonar(3)>=2*pi)
    posesonar(3)=posesonar(3)-2*pi;
end
if (posesonar(3)>pi)
    posesonar(3)=posesonar(3)-2*pi;  
end

% actualiza grid
gridk=gridk_1;
numchs=0;
for (x=1:numxs)
    for (y=1:numys)
        % busca el soporte del modelo inverso correspondiente a la observ.
        [centroceldax, centrocelday]=posicioncelda(x1,y1,xcelda,ycelda,x,y);
        % COMPLETAR: calcular d
        % COMPLETAR: calcular tita
        if (d>=zmax) | (d>=zk+anchobst/2) | (abs(tita-posesonar(3))>=aperturasensor)
            modif=0;
        else
            modif=1;
        end
        if (modif==1)
            if (abs(d-zk)<=anchobst/2) & (zk<zmax) % zona del ancho de los obstáculos centrada en la medida si la medida es buena
                gridk(x,y)=gridk(x,y)-l0+locc;
                numchs=numchs+1;
            else % zona intermedia del cono del sónar: libre de obstáculos si hemos visto esa observación
                gridk(x,y)=gridk(x,y)-l0+lfree;
                numchs=numchs+1;
            end            
        end
    end
end

return;
