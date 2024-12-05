
from Crypto.Hash import SHA256, HMAC
import base64
import json
import sys
from socket_class import SOCKET_SIMPLE_TCP
import funciones_aes
from Crypto.Random import get_random_bytes

# Paso 0: Inicializacion
########################
####EJERCICIO 2:---------------------------------------
# Lee clave KAT
KAT = open("KAT.bin", "rb").read()


# Crear el socket de conexion con T (5551)
print("Creando conexion con T...")
socket = SOCKET_SIMPLE_TCP('127.0.0.1', 5552)
socket.conectar()


# Paso 3) A->T: KAT(Alice, Na) en AES-GCM
#########################################
# Crea los campos del mensaje
t_n_origen = get_random_bytes(16)

# Codifica el contenido (los campos binarios en una cadena) y contruyo el mensaje JSON
msg_TE = []
msg_TE.append("Alice")
msg_TE.append(t_n_origen.hex())
json_ET = json.dumps(msg_TE)
print("A -> T (descifrado): " + json_ET)

# Cifra los datos con AES GCM
aes_engine = funciones_aes.iniciarAES_GCM(KAT)
cifrado, cifrado_mac, cifrado_nonce = funciones_aes.cifrarAES_GCM(aes_engine,json_ET.encode("utf-8"))

# Envia los datos
socket.enviar(cifrado)
socket.enviar(cifrado_mac)
socket.enviar(cifrado_nonce)


# Paso 4) T->A: KAT(K1, K2, Na) en AES-GCM
##########################################

# (A realizar por el alumno/a...)

socket.escuchar();

cifrado = socket.recibir()
cifrado_mac = socket.recibir()
cifrado_nonce = socket.recibir()

datosdes = funciones_aes.descifrarAES_CTR(KAT, cifrado_nonce,cifrado, cifrado_mac);

#pillamos la cadena:
jsonA = datosdes.decode("utf-8" ,"ignore");
print("T->A (descifrado): " + jsonA)
mensajeA = json.loads(jsonA)

K1,K2, nonceA = mensajeA
K1= bytearray.fromhex(K1);
K2= bytearray.fromhex(K2);
nonceA= bytearray.fromhex(nonceA);

if(nonceA==cifrado_nonce):
    print("Nonce de A correcto");
else:
    print("Nonce de A incorrecto");
    


# Cerramos el socket entre A y T, no lo utilizaremos mas
socket.cerrar() 

# Paso 5) A->B: KAB(Nombre) en AES-CTR con HMAC
###############################################

socket = SOCKET_SIMPLE_TCP('127.0.0.1', 5553)
socket.conectar()

msg_AB = []
msg_AB.append("Hola que tal")
json_AB = json.dumps(msg_AB)

print("A -> B (descifrado): " + json_AB)
print(json_AB.encode("utf-8"))

aes_ctr, nonce = funciones_aes.iniciarAES_CTR_cifrado(K1)
cifrado = funciones_aes.cifrarAES_CTR(aes_ctr, json_AB.encode("utf-8"))
datos_hmac = HMAC.new(K2, msg=json_AB.encode("utf-8"), digestmod=SHA256).digest()

socket.enviar(cifrado)
socket.enviar(nonce)
socket.enviar(datos_hmac)
# (A realizar por el alumno/a...)

# Paso 6) B->A: KAB(Apellido) en AES-CTR con HMAC
#################################################
cifrado = socket.recibir();
nonce = socket.recibir();
datos_hmac = socket.recibir();

aes_ctr_descifrado = funciones_aes.iniciarAES_CTR_descifrado(K1, nonce);
nombre = funciones_aes.descifrarAES_CTR(aes_ctr_descifrado, cifrado);
comprobar_hmac = HMAC.new(K2, msg=nombre, digestmod=SHA256);

try:
    comprobar_hmac.verify(datos_hmac)
except ValueError:
    print("Se violo la integridad")
nombre = nombre.decode("utf-8" ,"ignore")
print("B->A (descifrado): " + json.loads(nombre))

# Paso 7) A->B: KAB(END) en AES-CTR con HMAC
############################################


msg_AB = []
msg_AB.append("END")
json_AB = json.dumps(msg_AB)
print("B -> A (descifrado): " + json_AB)

aes_ctr, nonce = funciones_aes.iniciarAES_CTR_cifrado(K1)
cifrado = funciones_aes.cifrarAES_CTR(aes_ctr, json_AB.encode("utf-8"))
datos_hmac = HMAC.new(K2, msg=json_AB.encode("utf-8"), digestmod=SHA256).digest()

socket.enviar(cifrado)
socket.enviar(nonce)
socket.enviar(datos_hmac)
socket.cerrar()
print("Terminando programa")

