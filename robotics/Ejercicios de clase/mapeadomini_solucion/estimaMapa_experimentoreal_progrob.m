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
muestras=load('muestrasexpe060311_1103.log');
[nummuestras,aux]=size(muestras); % tiempo (msegs), encA (dcho,grados), encC (izdo,grados), sonar (cm)


% ------------------
% Carga de las poses
% ------------------
load('posespf.mat');	% ¿otra posibilidad de saber la localización? Usar un modelo cinemático, pero da muchos errores


% -----------------------
% Definición de variables
% -----------------------

% Entorno
entorno=[0,0,0,-0.935; 0,-0.935,-0.92,-0.935; -0.92,-0.935,-0.92,0; -0.92,0,0,0 ];
maxxp=max([entorno(:,1) ; entorno(:,3)]);
minxp=min([entorno(:,1) ; entorno(:,3)]);
maxyp=max([entorno(:,2) ; entorno(:,4)]);
minyp=min([entorno(:,2) ; entorno(:,4)]);

% Pose inicial
x0r=-0.265; y0r=-0.53; phi0r=pi;

% Datos del sónar
offsx=-0.005; % offset (X) del sensor sonar respecto al sistema de referencias del centro de movimiento del robot (X apuntando en PHI)
offsy=0.015; % offset (Y)
offsphi=pi/2; % incremento de ángulo respecto a PHI para la orientación del sónar
zmax=2; % máxima distancia devuelta por el sónar (metros)
resols=0.01; % resolución del sónar (centímetros; sólo devuelve valores desde 0 a zmax en este incremento)

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
	
pm0=0.5;	% probabilidad inicial
l0=log(pm0/(1-pm0));
probocc=0.75;	% probabilidad de ocupación
locc=log(probocc/(1-probocc));
lfree=log((1-probocc)/probocc);
anchobst=max(xcelda,ycelda);
anchoconosonar=pi/180*5;

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
        probcelda=1-1/(1+exp(grid(x,y)));
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

