
%Pieza inicial x = 0.2 y = -0.3250 z = 0.0350
clear;
close all;

s=Scorbot(Scorbot.MODEVREP);

s.home;
load('posiciones.mat');
%%current speed 60
s.changeSpeed(100);%mas velocidad
%pieza 1:
res = s.move(p1, 1);

s.changeGripper(1);
s.changeSpeed(50);

res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)-900]);
res = s.move(res, 1);
s.changeGripper(0);
res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)+900]);
res = s.move(res, 1);

s.changeSpeed(100);
res = s.move(p2, 1);
s.changeSpeed(50);
res = s.changePosXYZ(p2, [p2.xyz(1), p2.xyz(2)+50, p2.xyz(3)-900]);
s.move(res, 1);

s.changeGripper(1);
%%bajar un pelin mas(riesgo de muerte)
s.move(p2, 1);
s.changeSpeed(100);
s.move(p1,1);

%segunda pieza:
res = s.move(p1, 1);
s.changeSpeed(50);
s.changeGripper(1);
res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)-900]);
res = s.move(res, 1);
s.changeGripper(0);
res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)+900]);
res = s.move(res, 1);
s.changeSpeed(100);
res = s.changePosXYZ(p2, [p2.xyz(1), p2.xyz(2)-600, p2.xyz(3)]);
s.move(res, 1);

s.changeSpeed(50);
res = s.changePosXYZ(p2, [p2.xyz(1), p2.xyz(2)-600, p2.xyz(3)-900]);
s.move(res, 1);
s.changeGripper(1);
res = s.changePosXYZ(p2, [p2.xyz(1), p2.xyz(2)-600, p2.xyz(3)+900]);
s.move(res, 1);

%tercera pieza:
s.changeSpeed(100);
s.move(p1,1);
res= s.move(p1,1);
%res= s.changePosRoll(p1,600);
%res= s.move(res,1);
s.changeSpeed(50);

res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)-1200]);
res = s.move(res, 1);
s.changeGripper(0);
res = s.changePosXYZ(p1, [p1.xyz(1), p1.xyz(2), p1.xyz(3)+1200]);
res = s.move(res, 1);


s.changeSpeed(100);
res = s.changePosXYZ(p2, [p2.xyz(1)-20, p2.xyz(2)-220, p2.xyz(3)]);
s.move(res, 1);


s.changeSpeed(50);
res = s.changePosXYZ(p2, [p2.xyz(1)-20, p2.xyz(2)-220, p2.xyz(3)-720]);
s.move(res, 1);
res= s.changePosRoll(res,650);
res= s.move(res,1);
s.changeGripper(1);
res = s.changePosXYZ(p2, [p2.xyz(1)-20, p2.xyz(2)-220, p2.xyz(3)+720]);
s.move(res, 1);
