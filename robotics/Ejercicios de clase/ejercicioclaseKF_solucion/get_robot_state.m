% Generación del estado
function x_actual = get_transition(x_ant)

m = 1; % masa del robot
T = 0.5;   % período de muestreo
F = [1 T; 0 1]; % dinámica del proceso
G = [0 T/m]';   % relación entrada-dinámica
u = 0;  % entrada (para todo k = 0)
V = [0.2 0.05;0.05 0.1];  % covarianza de la transición
v = mvnrnd([0 0],V)'; %"instanciacion" del ruido

x_actual = F*x_ant+G*u+v;
