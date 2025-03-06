--1.-)-----------------------------------------------------------------
--Conéctate a la base de datos como system.
--2.-)-----------------------------------------------------------------
--Si tienes un problema de caducidad del password, utiliza el comando password  (Se aconseja actualizar la contraseña sin cambiarla, para no tener problemas posteriormente de olvido. Por supuesto, esta recomendación solo es válida en un sistema de pruebas, NUNCA EN PRODUCCIÓN).

--EN COMANDOS:
--SQLPLUS / AS SYSDBA
--select user from dual;
--
--si se olvida la contarseña:
--alter user system identified by abd;

-----EN SYSTEM-------------------------------------------------------------------------------------
--3.-)-----------------------------------------------------------------
--Comprobamos si existe un tablespace denominado TS_PLYTIX
SELECT * FROM DICT WHERE TABLE_NAME LIKE 'TABLESPACE'; --NO 

SELECT * FROM DBA_TABLESPACE;
SELECT COUNT(*) FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_PLYTIX';

--no hay, vamos a crearlo
--lo creamos:
--antes miramos donde crear el tablespace
SELECT * FROM V$DATAFILE;
--en el campo name vemos el directorio donde estan los otros archivos, copiamos la ruta y la añadimos al nuestro
-- SI NOS EQUIVOCAMOS:     drop tablespace TS_PLYTIX;   BORRA EL TABLESPACE
--LUEGO MOVEMOS EL DATAFILE DE SITIO EN VEZ DE BORRARLO POR SI ACASO
CREATE TABLESPACE TS_PLYTIX DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\plytix.dbf' SIZE 10M AUTOEXTEND ON;

--inicialmente reserva 10 Megas de bloques vacíos
--al tener el autoextend on, puede crecer de forma automatica



--4.-)------------------------------------------------------------------------
--Crea un perfil denominado PERF_ADMINISTRATIVO
--con 3 intentos para bloquear la cuenta
--y que se desconecte después de 5 minutos de inactividad

CREATE PROFILE PERF_ADMINISTRATIVO LIMIT
IDLE_TIME 5
FAILED_LOGIN_ATTEMPTS 3;

--5.-)------------------------------------------------------------------------
--Crea un perfil denominado PERF_USUARIO
--con 4 sesiones por usuario
--y con una password que caduca cada 30 días.

CREATE PROFILE PERF_USUARIO LIMIT
SESSIONS_PER_USER 4
PASSWORD_LIFE_TIME 30;

--6.-)-------------------------------------------------------------------------
--Asegúrate de que las limitaciones de recursos serán efectivas
--sin problemas. Y por supuesto, contesta a esta pregunta en tu script
--comentando cómo te has asegurado.

--Resource_limit=true
SHOW PARAMETERS RESOURCE_LIMIT;
--ya esta a true, luego las limitaciones de recursos seran efectivas sin problemas
--¿que pasaria si estuviera a false?:
--ALTER SYSTEM SET RESOURCE_LIMIT = TRUE; 
--Si no ponemos nada mas, se quedaactivo solo esta sesion, si lo queremos para siempre hacemos:
--ALTER SYSTEM SET RESOURCE_LIMIT = TRUE SCOPE=ALGO; 

--:---PREGUNTA EXAMEN------------------------
select *     --CUAL ES EL TAMAÑO DE.... ?
from v$sga;

SELECT * 
FROM v$sga_dynamic_components;
---------------------------------------------



--7.-)-------------------------------------------------------------------------
--Crea un role R_ADMINISTRADOR_SUPER con permiso para conectarse y crear tablas.

CREATE ROLE R_ADMINISTRADOR_SUPER;
GRANT CONNECT, CREATE TABLE TO R_ADMINISTRADOR_SUPER;

--8.-)-------------------------------------------------------------------------
--Crea dos usuarios denominados USUARIO1 y USUARIO2
--con perfil PERF_ADMINISTRATIVO
--y contraseña usuario.
--Otórgales el ROLE R_ADMINISTRADOR_SUPER.
--Asígneles Quota de 1 MB en el tablespace TS_PLYTIX.
--Haz que éste sea un tablespace por defecto.

CREATE USER usuario1 IDENTIFIED BY usuario
    DEFAULT TABLESPACE TS_PLYTIX
    QUOTA 1M ON TS_PLYTIX
    PROFILE PERF_ADMINISTRATIVO;


CREATE USER usuario2 IDENTIFIED BY usuario
    DEFAULT TABLESPACE TS_PLYTIX
    QUOTA 1M ON TS_PLYTIX
    PROFILE PERF_ADMINISTRATIVO;

GRANT R_ADMINISTRADOR_SUPER TO usuario1,usuario2;

--9.-)-------------------------------------------------------------------------
--En ambos usuarios crear la tabla TABLA2:

---------------------------------EN USUARIO1 Y USUARIO2--------------------------------------------------------------
CREATE TABLE TABLA2
( CODIGO NUMBER ) ;

--10.)-------------------------------------------------------------------------
--Crea el procedimiento USUARIO1.PR_INSERTA_TABLA2. Como aún no hemos visto procedimientos en ORACLE, simplemente haz un copia y pega de lo siguiente (la barra final debe escribirse también):

---------SYSTEM:----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE usuario1.PR_INSERTA_TABLA2 (
P_CODIGO IN NUMBER) AS
BEGIN
INSERT INTO TABLA2 VALUES (P_CODIGO);
END PR_INSERTA_TABLA2;
/

--11.-)------------------------------------------------------------------------
--Conéctate como USUARIO1 y Ejecútalo.
--¿Funciona?. Utiliza la instrucción exec nombre_procedimiento(param);
--CONSEJO: Utiliza SQLPlus si no quieres crear otra conexión para
--el usuario en SQL Developer.
--Conocer SQLPlus es buena idea, porque en algunos entornos solo
--encontrarás el terminal SQLPlus de Oracle.

--EN USUARIO1:
EXEC PR_INSERTA_TABLA2 (123);
commit;
select * from tabla2; --VEMOS Q SE AÑADIO 123 A LA COLUMNA CODIGO


--12.-)------------------------------------------------------------------------
--Otórgale permisos a USUARIO2 para ejecutarlo
GRANT EXECUTE ON usuario1.PR_INSERTA_TABLA2 TO usuario2;


--13.-)------------------------------------------------------------------------
--Conéctate como USUARIO2 y Ejecútalo. ¿Funciona? No olvides confirmar los cambios (commit)
--en usuario2: 
EXEC usuario1.PR_INSERTA_TABLA2 (234);
commit;
select * from tabla2; --no se inserto nada en la tabla de usuario2

--14.-)------------------------------------------------------------------------
--En este último caso ¿dónde se inserta el dato en la tabla de USUARIO1 o en la de USUARIO2? ¿Por qué?

--se inserta en la tabla de usuario1,ya que el procedimiento trabaja con su tabla 


--15.-)------------------------------------------------------------------------
--Cambiar el procedimiento para que el INSERT lo haga desde
--un EXECUTE IMMEDIATE. Es decir, vuelve a crear el procedimiento
--según vimos en el punto anterior pero sustituyendo la linea
--correspondiente al INSERT por
--execute immediate 'INSERT INTO TABLA2 VALUES ('||P_CODIGO||')';

CREATE OR REPLACE PROCEDURE usuario1.PR_INSERTA_TABLA2 (
P_CODIGO IN NUMBER) AS
BEGIN
execute immediate 'INSERT INTO TABLA2 VALUES ('||P_CODIGO||')';
END PR_INSERTA_TABLA2;
/



--16.-)------------------------------------------------------------------------
--Ejecutar desde USUARIO1. ¿Funciona?
--si funciona

--17.-)------------------------------------------------------------------------
--Ejecutar desde USUARIO2. ¿Funciona?
--si funciona

--18.-)------------------------------------------------------------------------
--Crear otro procedimiento en USUARIO1:
CREATE OR REPLACE PROCEDURE usuario1.PR_CREA_TABLA (
P_TABLA IN VARCHAR2, P_ATRIBUTO IN VARCHAR2) AS
BEGIN
EXECUTE IMMEDIATE 'CREATE TABLE '||P_TABLA||'('||P_ATRIBUTO||' NUMBER(9))';
END PR_CREA_TABLA;
/


--19.-)------------------------------------------------------------------------
--Ejecutar desde USUARIO1. ¿Funciona?¿Por qué?
--usuario1: 
exec PR_CREA_TABLA ( 'tabla1', 'atributo1'); --no funciona, porque no puede crear tablas por procedimientos?
--20.-)------------------------------------------------------------------------
--Asignemos permisos explícitos (y no a través de un rol
--como está ahora) de creación de tablas al USUARIO1.
--Asignar permisos de ejecución sobre el procedimiento anterior
--al USUARIO2.
--SYSTEM:
GRANT CREATE ANY TABLE TO usuario1;

--21.-)------------------------------------------------------------------------
--Ejecutar desde USUARIO2. ¿Funciona?¿Por qué? Piensa en los parámetros con los que se invoca.
GRANT EXECUTE ON usuario1.PR_CREA_TABLA TO usuario2; 
GRANT CREATE ANY TABLE TO usuario2;
--usuario2:
exec usuario1.PR_CREA_TABLA ( 'tabla3', 'atributo3');
--si funciona y le mete la tabla a usuario1

--22.-)------------------------------------------------------------------------
--Vamos ahora a comprobar cómo está la instalación de ORACLE
--que tenemos delante. En primer lugar, en una configuración
--óptima deberíamos conocer cuales son las cuentas que aún tienen
--su password por defecto (lo cual es una mala práctica desde el
--punto de vista de seguridad). Consulta para ello la vista de
--diccionario DBA_USERS_WITH_DEFPWD. Ahora, responde: ¿por qué
--hay tantas cuentas? ¿tan insegura es ORACLE tras la instalación?
--PISTA: Utiliza esa vista en combinación con otras que te permita
--estudiar el estado (si se pueden conectar, si están abiertas o
--bloqueadas, etc.) de esas cuentas.
--system:
SELECT USERNAME FROM DBA_USERS_WITH_DEFPWD;  --solo hay un user....


select * from dba_users;
SELECT u.username, u.account_status, u.lock_date, u.expiry_date
FROM dba_users_with_defpwd d
JOIN dba_users u ON d.username = u.username;

--23.-)------------------------------------------------------------------------
--Sabemos que existe un profile por defecto para la creación usuarios. 
--Vamos a modificarlo de manera que todos los usuarios cumplan una política mínima para la gestión de contraseñas al ser creados por defecto.
-- En primer lugar consulta cuales son los parámetros existentes del profile por defecto (la vista DBA_PROFILES puede ayudarte). Cuales son?
SELECT * 
FROM dba_profiles
WHERE profile = 'DEFAULT';
--Cambia el número de logins fallidos a 4 y el tiempo de gracia a 5 días.
ALTER PROFILE DEFAULT LIMIT 
  FAILED_LOGIN_ATTEMPTS 4 
  PASSWORD_GRACE_TIME 5;
-- Cambia el perfil del usuario1 al perfil por defecto y haz 5 logins fallidos. ¿Que ocurre la quinta vez? Para responder interpreta bien los mensajes que recibes.
ALTER USER usuario1 PROFILE DEFAULT; 
--al sexto intento me aparece que la cuenta esta bloqueada

-- Desbloquea la cuenta (alter user...)
alter user usuario1 account unlock;
-- A pesar de que hayamos cambiado el parámetro de failed_login_attempts, como habrás visto, es posible que antes, aunque el usuario no se bloquee, si nos eche de la sesión. Si consultamos el parámetro de inicialización sec_max_failed_login_attempts (show parameter...) aparece un valor menor (si no lo has cambiado antes). Significan por tanto diferentes cosas. ¿Para qué es útil cada uno?
-- Investiga si existe una forma de "quitar" los perfiles que hemos creado al principio. ¿Se puede hacer con todos los perfiles de oracle?
SHOW PARAMETER sec_max_failed_login_attempts;
ALTER USER usuario1 PROFILE DEFAULT;
--Una última pregunta.
--Algunos parámetros de inicialización son dinámicos, y otros estáticos. ¿Cual es la diferencia entre ellos?

--los dinamicos se pueden modificar sin necesidad de reiniciar la base de datos

--los estaticos necesitan reiniciar la bd