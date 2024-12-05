
import funciones_aes;
import funciones_rsa;
import socket_class;

##c. Cargar la clave privada de Alice y la clave pública de Bob. 
privA= funciones_rsa.cargar_RSAKey_Privada("privA.txt", "ok");
pubB= funciones_rsa.cargar_RSAKey_Publica("pubB.txt");


##d. Cifrar un array de 16 bytes (K1) utilizando la clave de Bob.

K1= funciones_aes.crear_AESKey();

K1Cif= funciones_rsa.cifrarRSA_OAEP(K1, pubB);

##e. Firmar dicho array de 16 bytes (K1) utilizando la clave de Alice.

K1Firma= funciones_rsa.firmarRSA_PSS(K1, privA);

#f. Enviar el cifrado y la firma usando un socket cliente de la clase
#SOCKET_SIMPLE_TCP(), descrita en los apéndices

socketclient = socket_class.SOCKET_SIMPLE_TCP('127.0.0.1', 5551)
socketclient.conectar()
socketclient.enviar(K1Cif)
socketclient.enviar(K1Firma)
array_bytes = socketclient.recibir()


##2------------------------------------------------

##b. Alice recibirá el texto cifrado con la clave simétrica y la firma digital a través del
#socket ya abierto en el apartado 1. Después, descifrará la cadena de caracteres y la
#mostrará por pantalla tras comprobar la validez de la firma digital.

cadenacif= socketclient.recibir();
cadenafirm= socketclient.recibir();
nonce= socketclient.recibir();

ctr= funciones_aes.iniciarAES_CTR_descifrado(K1,nonce);
cadena= funciones_aes.descifrarAES_CTR(ctr,cadenacif);

print(funciones_rsa.comprobarRSA_PSS(cadena,cadenafirm,pubB))
print(cadena);

##c. Finalmente, Alice repetirá los pasos a) y b) en reverso: enviando a Bob la cadena
#cifrada “Hola Bob” con K1 en AES-CTR-128, junto con la firma digital de dicha
#cadena, y Bob se encargará de descifrar y comprobar la firma digital.

cadena = "Hola Bob";
ctr,nonce= funciones_aes.iniciarAES_CTR_cifrado(K1);
cadenacif = funciones_aes.cifrarAES_CTR(ctr,bytes(cadena, 'utf-8'));
cadenafirm= funciones_rsa.firmarRSA_PSS(bytes(cadena,'utf-8'),privA);

socketclient.enviar(cadenacif);
socketclient.enviar(cadenafirm);
socketclient.enviar(nonce);

socketclient.cerrar()