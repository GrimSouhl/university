clear;
clc;
close all;

% Cargar datos (comenta/descomenta según lo que necesites)
load DatosAND
% load DatosLS5
% load DatosLS10
% load DatosLS50
% load DatosOR
%load DatosXOR

Data(:,end)=Data(:,end)==1;
% Inicializar pesos
W=[0, 0, 0]';

% Parámetros
Limites=[-1.5, 2.5, -1.5, 2.5];
%pseudo-inversa de la matriz
pinvX = pinv(Data(:, 1:end-1));
%Calcular los pesos:
W = pinvX * Data(:, end);


Output = Data(:, 1:end-1) * W;

%ECM
ECM = mean((Data(:, end) - Output).^2);

%Tasa de clasificación
Acc = sum(sign(Output) == Data(:, end)) / length(Data) * 100;


disp(['Pesos: ', num2str(W')]);
disp(['ECM: ', num2str(ECM)]);
disp(['Acc: ', num2str(Acc), '%']);


figure;
GrapDatos(Data, Limites);
GrapNeuron(W, Limites);
