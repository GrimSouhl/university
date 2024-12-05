import funciones_aes;
import funciones_rsa;
import socket_class;

##g. Cargar la clave privada de Bob y la clave pública de Alice.

privB= funciones_rsa.cargar_RSAKey_Privada("privB.txt", "ok");
pubA= funciones_rsa.cargar_RSAKey_Publica("pubA.txt");

##h. Recibir el texto cifrado y la firma digital a través del socket servidor de la clase
#SOCKET_SIMPLE_TCP(), descrita en los apéndices.

socketserver = socket_class.SOCKET_SIMPLE_TCP('127.0.0.1', 5551);
socketserver.escuchar();
K1Cif = socketserver.recibir()
K1Firma= socketserver.recibir();



##i. Descifrar el array de 16 bytes (K1) y mostrarlo por pantalla.

K1 = funciones_rsa.descifrarRSA_OAEP(K1Cif, privB);
print(K1);

##j. Comprobar la validez de la firma digital.

validez= funciones_rsa.comprobarRSA_PSS(K1, K1Firma, pubA);
print(validez);


###2.---------------------------------


##a. Tras el último paso del apartado 1, Bob cifrará la cadena “Hola Alice” utilizando AESCTR-128 con la clave K1, y firmará esa cadena con su clave privada. A continuación,
#enviará dicho cifrado y la firma a través del socket ya abierto en el apartado 1.

cadena = "Hola Alice";
ctr, nonce = funciones_aes.iniciarAES_CTR_cifrado(K1)
cifrado = funciones_aes.cifrarAES_CTR(ctr, bytes(cadena, 'utf-8'))
cadenacif = funciones_aes.cifrarAES_CTR(ctr,bytes(cadena, 'utf-8'));
cadenafirm= funciones_rsa.firmarRSA_PSS(bytes(cadena, 'utf-8'), privB);

socketserver.enviar(cadenacif);
socketserver.enviar(cadenafirm);
socketserver.enviar(nonce);

##c. Finalmente, Alice repetirá los pasos a) y b) en reverso: enviando a Bob la cadena
#cifrada “Hola Bob” con K1 en AES-CTR-128, junto con la firma digital de dicha
#cadena, y Bob se encargará de descifrar y comprobar la firma digital.

cadenacif= socketserver.recibir();
cadenafirm= socketserver.recibir();
nonce = socketserver.recibir()
ctr= funciones_aes.iniciarAES_CTR_descifrado(K1,nonce);
cadena= funciones_aes.descifrarAES_CTR(ctr,cadenacif);

print(funciones_rsa.comprobarRSA_PSS(cadena,cadenafirm,pubA));
print(cadena);
    
    
socketserver.cerrar();