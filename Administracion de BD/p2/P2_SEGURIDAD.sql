--2. Ejecuta todos los pasos necesarios para crear un wallet de tipo FILE, tal y como hemos visto en clase y en los videos, para permitir implementar TDE (Transparent Data Encryption) sobre columnas de las tablas que seleccionemos despu�s. 
--Hay que tener en cuenta que en el proceso de creaci�n del wallet se ha de elegir un directorio en el que Oracle tenga permisos en tu m�quina concreta. Por ejm, en el directorio 'C:\app\alumnos\admin\orcl\wallet' (que puedes crear) o cualquier otro directorio de Windows en el que aparezca el usuario de Oracle en el SO (el nombre de este usuario suele empezar con �ORA_�). Si no sabes c�mo comprobarlo, pregunta al profesor antes de continuar. Nota: No uses el directorio 'C:\app\alumnos\admin\orcl\xdb_wallet' como destino para WALLET_ROOT, ya que �ste es el wallet de Oracle XML Database (para las conexiones cifradas por HTTPS).
--Es necesario que entiendas bien TDE y todos los pasos que realizas. De lo contrario, te resultar� muy dif�cil avanzar en la pr�ctica. Para ello ve a la parte correspondiente de la documentaci�n proporcionada en clase y estudiala antes de empezar. Encontrar�s los pasos descritos en secuencia y explicados

--como ver donde esta la carpeta de oracle:
select NAME FROM V$DATAFILE;
--*****desde system:-----------------------------------------------------------------------------------
--Establecer el directorio d�nde se va a almacenar el keystore 
--1�)comillas dobles significa que es un identificador
ALTER SYSTEM SET "WALLET_ROOT"='C:\app\alumnos\admin\orcl\wallet' scope=SPFILE; --scope=spfile : se crea en el fichero de parametros
--variable que apunta a un string
--despues de ejecutar ese comando nos vamos a windows>servicios>reiniciamos el servicio OracleServiceORCL

--2�)Establecer el tipo de Keystore que vamos a utilizar:
ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;
--otra variable de entorno
--scope=both se puede hacer en runtime y se queda guardada
--no hace falta reiniciar nada en este caso

--quedan 3 variables m�s pero no se pueeden hacer con system
--*****desde syskm:--------------------------------------------------------------------------------------
--**EN CMD:
--SQLPLUS / AS SYSKM
--**EN SQLPLUS:
--ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY USUARIO;
--ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY  USUARIO;
--ADMINISTER KEY MANAGEMENT SET KEY force keystore identified by  USUARIO with backup;

----------------------------------------------------------------------------------------------------------
--system:
--3. Todo el trabajo de tu proyecto PLYTIX deber�a estar o estar� en un espacio de tablas aparte. En el peor de los casos puede estar en el tablespace USERS. Asumiremos en adelante que usamos el esquema en el que est�s desarrollando tu trabajo en grupo. Si no, no pasa nada, utiliza un esquema (usuario que tendr�s que crear) de ejemplo, el que quieras. M�s adelante, se volcar� lo aqu� aprendido al esquema final de PLYTIX.
SELECT * FROM DBA_TABLESPACES;

CREATE USER PLYTIX IDENTIFIED BY usuario;
ALTER USER PLYTIX quota 1M on TS_PLYTIX default tablespace TS_PLYTIX;
GRANT CONNECT TO PLYTIX;
GRANT CREATE TABLE TO PLYTIX;
GRANT INSERT ON PLYTIX.TEST1 TO PLYTIX;

--4. Usar una o varias tablas de tu trabajo en grupo susceptible de precisar que sus datos est�n cifrados. Si no tuvieras nada creado en el momento de la realizaci�n de esta pr�ctica, puedes crearte un par de tablas donde una de ellas fuera, por ejemplo, la de usuarios. Y, por supuesto, introducir algunos datos de ejemplo. Si tienes que crear estas tablas para la pr�ctica, lee el paso siguiente ANTES de hacerlo.
--**en plytix:------------------------------------------------------------------------------------
CREATE TABLE TEST1
(
    CODIGO NUMBER(2),
    SALARIO NUMBER(6) ENCRYPT
    
) TABLESPACE TS_PLYTIX;

--5. Parece obvio que en esas tablas habr� una serie de columnas que almacenan informaci�n sensible. Identif�calas y haz que est�n siempre cifradas en disco. PARA ESTA PR�CTICA, ASEGURATE QUE HAYA AL MENOS UNA COLUMNA DE TEXTO NO CIFRADA Y AL MENOS OTRA CIFRADA con objeto de poder hacer comprobaciones en los siguientes pasos.


--6. Una vez le has ordenado a Oracle las columnas que deben de ir cifradas, comprueba que los cambios son efectivos mediante la consulta de la vista del diccionario de datos adecuada.

select * from user_encrypted_columns; --ver todo lo encriptado



--7. Prueba a insertar varias filas en una de esas tablas (y en todas aquellas tablas que sea necesario). A continuaci�n, puedes forzar a Oracle a que haga un flush de todos los buffers a disco mediante la instrucci�n:
--en plytix:
INSERT INTO TEST1 VALUES (2,12);
INSERT INTO TEST1 VALUES (1,112);
INSERT INTO TEST1 VALUES (22,123);
INSERT INTO TEST1 VALUES (24,92);
--system:
alter system flush buffer_cache;

--Comprueba a continuaci�n el contenido del fichero que contiene el tablespace con estos datos. Ese fichero lo podremos encontrar en el directorio en el que hayamos creado el tablespace en el que se encuentra la tabla que estamos utilizando.
--No es necesario conocer el formato de dicho fichero. Simplemente tener en cuenta que los datos no cifrados aparecer�n en claro.  Y podemos hacer un buscar y los encontrar�amos. Pero, �y si hacemos lo mismo con los que hemos decidido que se almacenen cifrados?
--La manera m�s c�moda es utilizar una herramienta que extraiga los strings legibles. E.g.: https://docs.microsoft.com/en-us/sysinternals/downloads/strings
--Si el fichero no es muy grande tambi�n se puede utilizar un editor (e.g. notepad) de texto para abrirlo y realizar b�squedas. Responde a las siguientes preguntas:
-- �Se pueden apreciar en el fichero los datos escritos? �Por qu�?

SELECT tablespace_name, file_name
FROM dba_data_files
WHERE tablespace_name = 'TS_PLYTIX';

--en cmd:
--C:\Users\Usuario_UMA\Downloads\Strings>       strings C:\APP\ALUMNOS\ORADATA\ORCL\PLYTIX.DBF > salida.txt

--8. Vamos ahora a aplicar pol�ticas de autorizaci�n m�s concretas mediante VPD. Quiz�s quieras consultar previamente la documentaci�n de seguridad para refrescar los conceptos de VPD. 
--Supongamos que vamos a permitir a los usuarios acceder a la BD y consultar sus datos. Si un usuario accede, s�lo tendr� disponibles sus datos. Para ello, vamos a asumir que una de las columnas de la tabla usuarios almacena el "user" de conexi�n a la BD (a�ade esta columna a la tabla si no la tiene ya). En el ejemplo a continuaci�n asumimos que esta columna se denomina nombreusuario, pero puede denominarse como desees.
--Para ello, necesitaremos primero una funci�n que forme los predicados de la cl�usula WHERE. La crearemos en el esquema (con copiar y pegar, por ejemplo) en el que se encuentran las tablas:

create or replace function PLYTIX.vpd_function(p_schema varchar2, p_obj varchar2)
  Return varchar2
is
  Vusuario VARCHAR2(100);
Begin
  Vusuario := SYS_CONTEXT('userenv', 'SESSION_USER');
  return 'UPPER(nombreusuario) = ''' || Vusuario || '''';
End;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'PLYTIX',
    object_name     => 'USUARIOS',
    policy_name     => 'vpd_politica_usuarios',
    function_schema => 'PLYTIX',
    policy_function => 'vpd_function',
    statement_types => 'SELECT'
  );
END;
/

-- userenv = El contexto de aplicaci�n

-- p_obj es el nombre de la tabla o vista al cual se le aplicar� la pol�tica

-- p_schema es el schema en el que se encuentra dicha tabla o vista.



--9. Crearemos un usuario en Oracle (cuyo nombre debe estar previamente presente en el campo nombreusuario de alguna fila) de forma que podamos probar la pol�tica. Comprobaremos, que ese usuario, al conectarse, puede ver todos los datos de la tabla usuario (si no puede inicialmente, piensa por qu� y soluci�nalo).

--A partir de ahora, adem�s, ten en cuenta con que usuario vas a hacer cada cosa. Para crear, cancelar o borrar pol�ticas se har� desde un usuario con permisos de DBA (lo haremos as� por facilidad). Para probarlas se har� con el nuevo usuario que hemos creado precisamente para eso. En resumen, cada vez que se solicite llevar a cabo una acci�n, incluso si el enunciado no lo especifica, no debes dudar acerca de cu�l es el usuario que ha de hacerlo. Si dudas, pregunta al profesor.

--Recuerda tambi�n que siempre que creemos usuarios de prueba ser� asign�ndole los permisos M�NIMOS necesarios para lo que queremos hacer (ni uno m�s).

--A�adiremos la pol�tica (consulta las transparencias) a la tabla USUARIO (desde un usuario con el role de DBA).  Y despu�s comprobaremos que ocurre despu�s de a�adir la pol�tica. Una aclaraci�n, al a�adir una pol�tica, �sta se encuentra activa por defecto.

create user pepe identified by usuario;
alter user pepe quota 1M on TS_PLYTIX default tablespace TS_PLYTIX;
grant connect to pepe;
grant create table to pepe;
GRANT SELECT ON PLYTIX.USUARIOS TO PEPE;

--EN PLYTIX:
CREATE TABLE USUARIOS (
  ID NUMBER PRIMARY KEY,
  NOMBRE VARCHAR2(100),
  EMAIL VARCHAR2(100),
  nombreusuario VARCHAR2(100) 
) TABLESPACE TS_PLYTIX;
INSERT INTO USUARIOS VALUES (1, 'Juan P�rez', 'juan@email.com', 'PEPE');
INSERT INTO USUARIOS VALUES (2, 'Ana G�mez', 'ana@email.com', 'PLYTIX');

--Si en alg�n momento necesitas desactivar la pol�tica puedes usar:

begin

 DBMS_RLS.ENABLE_POLICY (        object_schema=>'el_nombre_del_esquema_en_el_que_est�_la_tabla',    object_name=>'el_nombre_de_tu_tabla',

policy_name=>'nombre_politica', enable=>false);

end;

--Si te has equivocado y quieres borrar y volver a crear la pol�tica:

begin

dbms_rls.drop_policy (

  object_schema=>'el_esquema',

  object_name=>'la_tabla',

  policy_name=>'el_nombre_de_la_politica' );

end;

--10.  �Qu� ocurre cuando nos conectamos con ese usuario existente en la tabla USUARIO y realizamos un select de todo? �Y cu�ndo lo hace el propietario de la tabla?
SELECT * FROM PLYTIX.USUARIOS; --EN PEPE
--SOLO VE SU FILA

--11. Utilizando VPD, tambi�n podemos aplicar pol�ticas sobre columnas, en lugar de sobre vistas o tablas enteras. Continuando con nuestro ejemplo, imaginemos que queremos permitir a estos usuarios consultar todos los datos de la tabla excepto cuando tambi�n se solicita una columna determinada (ej. Telefono), en cuyo caso queremos que se muestren s�lo los datos del usuario. Investiga en la documentaci�n la funci�n que ya hemos utilizado del paquete dbms_rls para a�adir una pol�tica nueva (dbms_rls.add_policy). �Qu� cambios deber�amos hacer para lograr nuestro objetivo? Tip: Desactiva previamente la pol�tica anterior para no tener conflictos en los resultados. 

BEGIN
  DBMS_RLS.ENABLE_POLICY(
    object_schema => 'PLYTIX',
    object_name   => 'USUARIOS',
    policy_name   => 'vpd_politica_usuarios',
    enable        => FALSE
  );
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'USUARIOS',
    policy_name     => 'vpd_politica_columnas',
    function_schema => 'PLYTIX',
    policy_function => 'vpd_function_columnas',
    statement_types => 'SELECT',
    sec_relevant_cols => 'EMAIL',  
    sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS
  );
END;
/
--12. �Qu� desventajas pueden llegar a tener este tipo de control de acceso m�s espec�fico? Si no encuentras la respuesta disc�telo con el profesor.
--menor transparencia
--dificil de depurar

--13. A continuaci�n se detallan los distintos tipos de usuarios que existir�n en la BD. Para la correcta gesti�n de ellos se deber�n crear los roles, usuarios, vistas, permisos, etc. que sean precisos. Se recomienda comenzar por el usuario Administrador porque resultar� de utilidad para el resto de usuarios, roles y privilegios.

--Los usuarios o grupos de usuarios ser�n los siguientes:

--Administrador del Sistema: Tiene control total sobre todas las tablas y es responsable de la seguridad (TDE y VPD). Puede crear, modificar y eliminar cuentas, usuarios, productos, activos y planes
--Usuario Est�ndar: Puede ver y modificar su propia informaci�n en Usuario. Puede acceder a productos y activos de su cuenta y dar de alta estos elementos. Puede acceder a su Plan asociado.
--Gestor de Cuentas: Accede y administra la tabla Cuenta. Puede modificar los datos de las cuentas (Nombre, Direcci�nFiscal, NIF, etc.). No tiene acceso a datos sensibles de Usuario (Email, Tel�fono).
--Planificador de Servicios: Administra la tabla Plan y sus relaciones (Productos, Activos, Categor�asProducto, Categor�asActivos). Puede definir planes y modificar los elementos que los componen.
--Para  la mayor�a de estos tipos de usuarios deberemos discriminar qu� individuo es el que est� trabajando, esto puede hacerse creando un usuario particular para cada uno de ellos o bien mantener un usuario com�n para cada grupo y a�adiendo alg�n tipo de mecanismo que permita discriminar qu� usuario es el que est� conectado (por ejemplo controlando variables o el contexto de la sesi�n, usando tablas temporales basadas en sesiones -on commit preserve rows- que almacenen el identificador particular de la persona que est� conectada, etc).



CREATE ROLE rol_admin;
GRANT ALL PRIVILEGES TO rol_admin;
CREATE ROLE rol_usuario_estandar;
CREATE ROLE rol_gestor_cuentas;

CREATE USER admin IDENTIFIED BY admin123;
CREATE USER planificador IDENTIFIED BY planificador123;
CREATE USER gestor IDENTIFIED BY gestor123;
CREATE USER usuario1 IDENTIFIED BY usu123;

GRANT SELECT, UPDATE (nombre, direccionfiscal, NIF) ON cuenta TO rol_gestor_cuentas;
CREATE ROLE rol_planificador;
GRANT SELECT, INSERT, UPDATE, DELETE ON plan TO rol_planificador;
GRANT rol_admin TO admin;
GRANT rol_usuario_estandar TO usuario1;
GRANT rol_gestor_cuentas TO gestor;
GRANT rol_planificador TO planificador;

