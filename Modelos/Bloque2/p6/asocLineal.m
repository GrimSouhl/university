clear all;

X = rand(4,5);
Y = rand(4,2);
A = rand(4,5);
B = rand(4,2);

X = orth(X')';
%Y = orth(Y')';
w1 = X'*Y; % Vector de pesos aplicando pseudoinversa
w2 = A'*B;

Y_pred = X * w1 % Recuperamos el valor
B_pred = A * w2 % No se recupera ya que no son ortonormales
