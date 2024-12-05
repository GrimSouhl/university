% Generación de la observación tomada por el robot
% a partir del estado del robot.
%
% En este ejercicio se utiliza el modelo de observación para ello,
% pero no tiene que ser así, podría usarse otra expresión
% simulada o del robot real.

function y_actual = get_sensor_reading(x_ant)

H = [0 1]; % sensores
W = 0.5; % covarianza sensores
w = sqrt(W).*randn;

y_actual = H*x_ant+w;
