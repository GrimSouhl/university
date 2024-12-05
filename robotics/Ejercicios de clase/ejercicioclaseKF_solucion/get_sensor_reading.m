% Generación de la observación
function y_actual = get_observation(x_ant)

H = [0 1]; % sensores
W = 0.5; % covarianza sensores
w = sqrt(W).*randn;

y_actual = H*x_ant+w;
