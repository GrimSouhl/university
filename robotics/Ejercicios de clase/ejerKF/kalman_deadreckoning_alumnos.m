% -------------------------------------------------------
%
% IMPLEMENTACIÓN DEL FILTRO DE KALMAN PARA DEAD RECKONING
%
% (Basado en Choset et al., pág 285)
%
% Ana Cruz Martín, 2013
%
% -------------------------------------------------------

k = 2;  % indice inicial
fin = 100;  % duración del experimento

m = 1;	% COMPLETAR: masa del robot
T = 0.5; 	% COMPLETAR: período de muestreo
F = [1 T ; 0 1]; 	% COMPLETAR: dinámica del proceso
G = [0 ; T/m7];	% COMPLETAR: relación entrada-dinámica
H = [0 1];

W = 0.5;   % COMPLETAR: covarianza del ruido del sensor
V = [0.2 0.05 : 0.05 0.1];   % COMPLETAR: covarianza del ruido del proceso

u = 0;	% entrada del sistema (0 para todo k)
x_real = [1.8 2]';    % estado real (desconocido para el robot)

x_est = {};  % estado estimado
x_est{k-1} = [2 4]'; % valor inicial del estado estimado [posicion velocidad]
x_est_inter = [];   % estado estimado intermedio

x_trans = {};  % estado del robot al moverse
x_trans{k-1} = x_real;

P = {};	% covarianza
P{k-1} = [1 0 ; 0 2];	% COMPLETAR: covarianza inicial
P_inter = {};	% covarianza intermedia

y = {}; % observaciones (el sensor sólo mide la velocidad)
ipsilon = {};
S = {};

% Filtro de Kalman
while (k<=fin)
    
    % mundo (en este caso, no es real sino simulado)
    x_trans{k} = get_robot_state(x_trans{k-1});
    y{k} = get_sensor_reading(x_trans{k});
    
    % predicción
    x_est_inter{k} =F*x_est{k-1}+G*u ;	% COMPLETAR
    P_inter{k} = F*P*(F')*V;	% COMPLETAR:
    
    % actualización

    ipsilon{k} = y-H*x_est_inter;	% COMPLETAR
    S{k} = H*P*H'+W;	% COMPLETAR
    R{k} = P*H'*(inv(S));	% COMPLETAR
    
    x_est{k} =  x_est_inter{k}+R{k}*ipsilon ;	% COMPLETAR
    P{k} =P-R{k}*H*P;	% COMPLETAR
    
    k = k+1;
end


% Dibujo delos resultados
%axis([-2 30 -2 30]);
hold on;
plot(x_est{1}(1),x_est{1}(2),'r*'); % estado estimado inicial
plot(x_real(1),x_real(2),'bo'); % estado real inicial
xlabel('Posicion');
ylabel('Velocidad');
title('Filtro de Kalman');
for k=1:fin,
    plot([x_est{k}(1) x_trans{k}(1)],[x_est{k}(2) x_trans{k}(2)],'c-');
    plot(x_est{k}(1),x_est{k}(2),'g.'); % estado estimado
    plot(x_trans{k}(1),x_trans{k}(2),'ms'); % estado del robot al moverse
    if (mod(k,10) == 0) plotcov2d([x_est{k}(1) x_est{k}(2)],[P{k}(1,1) P{k}(1,2);P{k}(2,1) P{k}(2,2)],'b'); end;
end
plot(x_est{k}(1),x_est{k}(2),'kd');
