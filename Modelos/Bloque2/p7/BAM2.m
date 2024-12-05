clear all;
barco= load('D:/AModelosComputacion/MODULO2/p7/Matrices/barco.mat');
coche=load('D:/AModelosComputacion/MODULO2/p7/Matrices/coche.mat');
textoBarco= load('D:/AModelosComputacion/MODULO2/p7/Matrices/textoBarco.mat');
textoCoche=load('D:/AModelosComputacion/MODULO2/p7/Matrices/textoCoche.mat');

x(1,:)= reshape(barco.barco, 1, size(barco.barco,1)*size(barco.barco,2));
x(2,:)= reshape(coche.coche, 1, size(coche.coche,1)*size(coche.coche,2));
y(1,:)= reshape(textoBarco.textoBarco, 1, size(textoBarco.textoBarco,1)*size(textoBarco.textoBarco,2));
y(2,:)= reshape(textoCoche.textoCoche, 1, size(textoCoche.textoCoche,1)*size(textoCoche.textoCoche,2));

w= x'*y;

epocmax=21;
s= zeros(size(x,2),epocmax); %%para las x
s2= zeros(size(y,2),epocmax); %%para las y
%%Patron de inicio:
%ruido:
sinit=imnoise([x(1,:)],'gaussian',0,0.5)*2-1;
%%coche:
%sinit=imnoise([x(2,:)],'gaussian',0,0.5)*2-1;
%--ssin ruido-----
%%sinit = [x(1,:)];
%coche:
%sinit = [x(2,:)];
s2init=sign(sinit*w);

s(:,1)= sinit;
s2(:,1)= s2init;


for epoc=2 :1:epocmax
    s(:,epoc)=sign(w*s2(:,epoc-1));
    s2(:,epoc)=sign(s(:,epoc)'*w);
    if(sum(s(:,epoc)==s(:,epoc-1))==size(x,2))
        subplot(3,1,1)
        imshow(reshape(s(:,1),size(barco.barco,1),size(barco.barco,2)));
        subplot(3,1,2)
        imshow(reshape(s(:,epoc),size(barco.barco,1),size(barco.barco,2)));
        subplot(3,1,3)
        imshow(reshape(s2(:,epoc),size(textoBarco.textoBarco,1),size(textoBarco.textoBarco,2)));
        break;
    end
end

