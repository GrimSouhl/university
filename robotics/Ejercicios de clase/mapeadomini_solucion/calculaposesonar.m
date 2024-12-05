function poses=calculaposesonar(poser,offsx,offsy,offsphi)
% Dada la pose del robot y los offsets del sónar respecto al centro de
% movimiento del robot, devuelve la pose del sónar en el sistema universal

c=cos(poser(3));
s=sin(poser(3));
T=[c -s 0 poser(1); s c 0 poser(2); 0 0 1 poser(3); 0 0 0 1];
posesu=T*[offsx;offsy;offsphi;1];
poses=[posesu(1) posesu(2) posesu(3)];

return;