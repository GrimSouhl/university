% --------------------------------------------------------------
% PROGRAMACIÓN DE ROBOTS
% Script para la estimación de un mapa de rejilla probabilístico
% Basado en Fernández-Madrigal y Blanco-Claraco (2013)
% ---------------------------------------------------------------

clear;
close all;

% ---------------------
% Carga de las muestras
% ---------------------
% COMPLETAR: carga del fichero de muestras
[nummuestras,aux]=size(muestras); % tiempo (msegs), encA (dcho,grados), encC (izdo,grados), sonar (cm)


% ------------------
% Carga de las poses
% ------------------
% COMPLETAR: carga del fichero de poses


% -----------------------
% Definición de variables
% -----------------------

% Entorno
entorno=[0,0,0,-0.935; 0,-0.935,-0.92,-0.935; -0.92,-0.935,-0.92,0; -0.92,0,0,0 ];
maxxp=max([entorno(:,1) ; entorno(:,3)]);
minxp=min([entorno(:,1) ; entorno(:,3)]);
maxyp=max([entorno(:,2) ; entorno(:,4)]);
minyp=min([entorno(:,2) ; entorno(:,4)]);


% COMPLETAR: Pose inicial


% COMPLETAR: Datos del sónar


% Celdas del mapa
xcelda=0.02;
ycelda=0.02;
margenent=0.1;
maxxp=maxxp+margenent;
minxp=minxp-margenent;
maxyp=maxyp+margenent;
minyp=minyp-margenent;
tamx=ceil((maxxp-minxp)/xcelda);
tamy=ceil((maxyp-minyp)/ycelda);


% -------------------
% Estimación del mapa
% -------------------

fprintf('Estimando occupancy grid...\n');

fprintf('Mapa de %d por %d celdas\n',tamx,tamy);

% COMPLETAR: Definición de probabilidades y logs	
pm0=;	% probabilidad inicial
l0=
probocc=	% probabilidad de ocupaciï¿½n
locc=;
lfree=;
anchobst=max(xcelda,ycelda);
anchoconosonar=;

occgrid=ones(tamx,tamy)*l0; % logodds 0
[numxs,numys]=size(occgrid);
x1=minxp+xcelda/2; y1=minyp+ycelda/2;	% centro de la primera celda
grids=cell(nummuestras,1);	% cell array de grids
grids{1,1}=occgrid;
for (f=2:nummuestras)
    if (mod(f,floor(nummuestras/10))==0)
        fprintf('\n%d%%\n',f/floor(nummuestras/10)*10);
    end
    [occgrid,numcs]=actualizagrid(occgrid,l0,x1,y1,xcelda,ycelda,poses(f,:),muestras(f,4)/100,offsx,offsy,offsphi,...
                                  zmax,anchobst,anchoconosonar,locc,lfree);
    grids{f,1}=occgrid;
end
fprintf('\n');


% ----------
% Resultados
% ----------

fprintf('Dibujando resultados...\n');
[nps,aux]=size(entorno);


% Dibuja occupancy grids

figure; % no animado
grid;
hold on;
axis([minxp maxxp minyp maxyp]);

grid=grids{nummuestras,1};
for (x=1:numxs)
    for (y=1:numys)
        % Completar: calcular la probabilidad de la celda
        [cx,cy]=posicioncelda(x1,y1,xcelda,ycelda,x,y);
        rectangle('Position',[cx-xcelda/2 cy+ycelda/2 xcelda ycelda],...
                  'LineWidth',1,'LineStyle','-',...
                  'FaceColor',[1-probcelda 0 0]);
    end
end

plot([-0.05 0.05],[0 0],'k-','LineWidth',3);
plot([0 0],[-0.05 0.05],'k-','LineWidth',3);
for (g=1:nps)
    plot([entorno(g,1) entorno(g,3)],[entorno(g,2) entorno(g,4)],'k-','LineWidth',3);
end

plot(poses(:,1),poses(:,2),'b.:');

