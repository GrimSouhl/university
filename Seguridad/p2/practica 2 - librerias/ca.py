
import funciones_rsa;

##a. Crear una clave pública y una clave privada RSA de 2048 
# bits para Alice. Guardar cada clave en un fichero.

keyA = funciones_rsa.crear_RSAKey();

privA=keyA;
pubA= keyA.public_key();

funciones_rsa.guardar_RSAKey_Privada("privA.txt", privA, "ok");
funciones_rsa.guardar_RSAKey_Publica("pubA.txt", pubA)
##b. Crear una clave pública y una clave privada RSA de 2048 
# bits para Bob. Guardar cada clave en un fichero.

keyB = funciones_rsa.crear_RSAKey();

privB=keyB;
pubB= keyB.public_key();

funciones_rsa.guardar_RSAKey_Privada("privB.txt", privB, "ok");
funciones_rsa.guardar_RSAKey_Publica("pubB.txt", pubB)