clear all;
clc;
d(:,:,1)=[1 1 -1 -1 -1 1 1; 1 1 -1 1 -1 1 1; 1 1 -1 1 -1 1 1;1 1 -1 1 -1 1 1; 1 -1 -1 -1 -1 -1 1;
1 -1 1 1 1 -1 1; 1 -1 1 1 1 -1 1; 1 -1 1 1 1 -1 1; -1 -1 1 1 1 -1 -1;];
d(:,:,2)=[1 -1 -1 -1 -1 -1 1;  1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 -1 -1 -1 -1 1;  1 -1 1 1 1 1 -1;1 -1 1 1 1 1 -1;
1 -1 1 1 1 1 -1; 1 -1 -1 -1 -1 -1 1;];
d(:,:,3)=[1 -1 -1 -1 -1 -1 -1; 
-1 1 1 1 1 1 1; -1 1 1 1 1 1 1; -1 1 1 1 1 1 1; -1 1 1 1 1 1 1; -1 1 1 1 1 1 1; -1 1 1 1 1 1 1; -1 1 1 1 1 1 1; 1 -1 -1 -1 -1 -1 -1;];
d(:,:,4)=[1 -1 -1 -1 -1 -1 1; 1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1;
1 -1 1 1 1 1 -1; 1 -1 1 1 1 1 -1; 1 -1 -1 -1 -1 -1 1;];
d(:,:,5)=[-1 -1 -1 -1 -1 -1 -1; -1 1 1 1 1 1 1;-1 1 1 1 1 1 1;-1 1 1 1 1 1 1;-1 -1 -1 -1 -1 -1 1;-1 1 1 1 1 1 1;-1 1 1 1 1 1 1;
-1 1 1 1 1 1 1;-1 -1 -1 -1 -1 -1 -1;];


w = zeros(9*7, 9*7);
dVect = zeros(5, 9*7);

for i=1:5
    dVect(i,:) = reshape(d(:,:,i), 1, 9*7);
    w = w + dVect(i, :)'*dVect(i,:);        % Sumatorio de los elementos
end

w = (1/size(w,1))*w;    % Sumatorio de k
w = w - diag(diag(w));  % Autoasociaciones


numIt = 2;

for k=1:1:5
    S = zeros(size(w,1), numIt);
    t=1;
    S(:,t) = dVect(k,:);
    disp("Modelo partida"); 
    reshape(S(:,t), 9, 7)

    cambio = false;
    for t=2:1:numIt

        for l=1:k
            h = sum(S(l,t)'.*w(l,:), "all");    % 
            S(l,t) = (h>0)*2-1;                 % Mantener en la escala {-1, 1}
    
            cambio = cambio || S(l,t) ~= S(l, t-1);
    
            if ~cambio
                disp("Modelo final");
                t
                reshape(S(:,l), 9, 7)
                break
            end
        end
    end
 
    
end

