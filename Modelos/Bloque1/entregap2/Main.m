clear;
clc;
close all;

%load DatosAND
%load DatosLS5
%load DatosLS10
%load DatosLS50
%load DatosOR
load DatosXOR

Data(:,end)=Data(:,end)==1;

LR=0.5;
Limites=[-1.5, 2.5, -1.5, 2.5];
MaxEpoc=100;

W=[0,0,0]';

Epoc=1;
ECM_vector = [];

while ~CheckPattern(Data,W) && Epoc<MaxEpoc
     ECM_epoch=0;
    for i=1:size(Data,1)
        [Input,Output,Target]=ValoresIOT(Data,W,i);
        
        %GrapDatos(Data,Limites);
        %GrapPatron(Input,Output,Limites);
        %GrapNeuron(W,Limites);hold off;
        %drawnow
%         pause

        E = ((Target-Output)^2)/2;
        ECM_epoch = ECM_epoch + E;

        if Signo(Output)~=Target
           W=UpdateNet(W,LR,Signo(Output),Target,Input);
        end
    end
        ECM_vector = [ECM_vector,ECM_epoch/size(Data,1)];
        Epoc = Epoc+1;
        %GrapDatos(Data,Limites);
        %GrapPatron(Input,Output,Limites)
        %GrapNeuron(W,Limites);hold off;
        %drawnow
%         pause;
     
end  
figure;
plot(1:length(ECM_vector), ECM_vector, '-o');
title('Evolución del Error Cuadrático Medio (ECM) por época');
xlabel('Época');
ylabel('ECM');
grid on;
   


if CheckPattern(Data,W)
     disp("todo bien")
else
    disp("mal")
end
