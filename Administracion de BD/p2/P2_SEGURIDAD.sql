--2. Ejecuta todos los pasos necesarios para crear un wallet de tipo FILE, tal y como hemos visto en clase y en los videos, para permitir implementar TDE (Transparent Data Encryption) sobre columnas de las tablas que seleccionemos después. 
--Hay que tener en cuenta que en el proceso de creación del wallet se ha de elegir un directorio en el que Oracle tenga permisos en tu máquina concreta. Por ejm, en el directorio 'C:\app\alumnos\admin\orcl\wallet' (que puedes crear) o cualquier otro directorio de Windows en el que aparezca el usuario de Oracle en el SO (el nombre de este usuario suele empezar con ‘ORA_”). Si no sabes cómo comprobarlo, pregunta al profesor antes de continuar. Nota: No uses el directorio 'C:\app\alumnos\admin\orcl\xdb_wallet' como destino para WALLET_ROOT, ya que éste es el wallet de Oracle XML Database (para las conexiones cifradas por HTTPS).
--Es necesario que entiendas bien TDE y todos los pasos que realizas. De lo contrario, te resultará muy difícil avanzar en la práctica. Para ello ve a la parte correspondiente de la documentación proporcionada en clase y estudiala antes de empezar. Encontrarás los pasos descritos en secuencia y explicados

--como ver donde esta la carpeta de oracle:
select NAME FROM V$DATAFILE;
--*****desde system:-----------------------------------------------------------------------------------
--Establecer el directorio dónde se va a almacenar el keystore 
--1º)comillas dobles significa que es un identificador
ALTER SYSTEM SET "WALLET_ROOT"='C:\app\alumnos\admin\orcl\wallet' scope=SPFILE; --scope=spfile : se crea en el fichero de parametros
--variable que apunta a un string
--despues de ejecutar ese comando nos vamos a windows>servicios>reiniciamos el servicio OracleServiceORCL

--2º)Establecer el tipo de Keystore que vamos a utilizar:
ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;
--otra variable de entorno
--scope=both se puede hacer en runtime y se queda guardada
--no hace falta reiniciar nada en este caso

--quedan 3 variables más pero no se pueeden hacer con system
--*****desde syskm:--------------------------------------------------------------------------------------
--**EN CMD:
--SQLPLUS / AS SYSKM
--**EN SQLPLUS:
--ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY USUARIO;
--ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY  USUARIO;
--ADMINISTER KEY MANAGEMENT SET KEY force keystore identified by  USUARIO with backup;

----------------------------------------------------------------------------------------------------------
--system:
--3. Todo el trabajo de tu proyecto PLYTIX debería estar o estará en un espacio de tablas aparte. En el peor de los casos puede estar en el tablespace USERS. Asumiremos en adelante que usamos el esquema en el que estás desarrollando tu trabajo en grupo. Si no, no pasa nada, utiliza un esquema (usuario que tendrás que crear) de ejemplo, el que quieras. Más adelante, se volcará lo aquí aprendido al esquema final de PLYTIX.
SELECT * FROM DBA_TABLESPACES;

CREATE USER PLYTIX IDENTIFIED BY usuario;
ALTER USER PLYTIX quota 1M on TS_PLYTIX default tablespace TS_PLYTIX;
GRANT CONNECT TO PLYTIX;
GRANT CREATE TABLE TO PLYTIX;
GRANT INSERT ON PLYTIX.TEST1 TO PLYTIX;

--4. Usar una o varias tablas de tu trabajo en grupo susceptible de precisar que sus datos estén cifrados. Si no tuvieras nada creado en el momento de la realización de esta práctica, puedes crearte un par de tablas donde una de ellas fuera, por ejemplo, la de usuarios. Y, por supuesto, introducir algunos datos de ejemplo. Si tienes que crear estas tablas para la práctica, lee el paso siguiente ANTES de hacerlo.
--**en plytix:------------------------------------------------------------------------------------
CREATE TABLE TEST1
(
    CODIGO NUMBER(2),
    SALARIO NUMBER(6) ENCRYPT
    
) TABLESPACE TS_PLYTIX;

--5. Parece obvio que en esas tablas habrá una serie de columnas que almacenan información sensible. Identifícalas y haz que estén siempre cifradas en disco. PARA ESTA PRÁCTICA, ASEGURATE QUE HAYA AL MENOS UNA COLUMNA DE TEXTO NO CIFRADA Y AL MENOS OTRA CIFRADA con objeto de poder hacer comprobaciones en los siguientes pasos.


--6. Una vez le has ordenado a Oracle las columnas que deben de ir cifradas, comprueba que los cambios son efectivos mediante la consulta de la vista del diccionario de datos adecuada.

select * from user_encrypted_columns; --ver todo lo encriptado



--7. Prueba a insertar varias filas en una de esas tablas (y en todas aquellas tablas que sea necesario). A continuación, puedes forzar a Oracle a que haga un flush de todos los buffers a disco mediante la instrucción:
--en plytix:
INSERT INTO TEST1 VALUES (2,12);
INSERT INTO TEST1 VALUES (1,112);
INSERT INTO TEST1 VALUES (22,123);
INSERT INTO TEST1 VALUES (24,92);
--system:
alter system flush buffer_cache;

--Comprueba a continuación el contenido del fichero que contiene el tablespace con estos datos. Ese fichero lo podremos encontrar en el directorio en el que hayamos creado el tablespace en el que se encuentra la tabla que estamos utilizando.
--No es necesario conocer el formato de dicho fichero. Simplemente tener en cuenta que los datos no cifrados aparecerán en claro.  Y podemos hacer un buscar y los encontraríamos. Pero, ¿y si hacemos lo mismo con los que hemos decidido que se almacenen cifrados?
--La manera más cómoda es utilizar una herramienta que extraiga los strings legibles. E.g.: https://docs.microsoft.com/en-us/sysinternals/downloads/strings
--Si el fichero no es muy grande también se puede utilizar un editor (e.g. notepad) de texto para abrirlo y realizar búsquedas. Responde a las siguientes preguntas:
-- ¿Se pueden apreciar en el fichero los datos escritos? ¿Por qué?

SELECT tablespace_name, file_name
FROM dba_data_files
WHERE tablespace_name = 'TS_PLYTIX';

--en cmd:
--C:\Users\Usuario_UMA\Downloads\Strings>       strings C:\APP\ALUMNOS\ORADATA\ORCL\PLYTIX.DBF > salida.txt

--8. Vamos ahora a aplicar políticas de autorización más concretas mediante VPD. Quizás quieras consultar previamente la documentación de seguridad para refrescar los conceptos de VPD. 
--Supongamos que vamos a permitir a los usuarios acceder a la BD y consultar sus datos. Si un usuario accede, sólo tendrá disponibles sus datos. Para ello, vamos a asumir que una de las columnas de la tabla usuarios almacena el "user" de conexión a la BD (añade esta columna a la tabla si no la tiene ya). En el ejemplo a continuación asumimos que esta columna se denomina nombreusuario, pero puede denominarse como desees.
--Para ello, necesitaremos primero una función que forme los predicados de la cláusula WHERE. La crearemos en el esquema (con copiar y pegar, por ejemplo) en el que se encuentran las tablas:

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

-- userenv = El contexto de aplicación

-- p_obj es el nombre de la tabla o vista al cual se le aplicará la política

-- p_schema es el schema en el que se encuentra dicha tabla o vista.



--9. Crearemos un usuario en Oracle (cuyo nombre debe estar previamente presente en el campo nombreusuario de alguna fila) de forma que podamos probar la política. Comprobaremos, que ese usuario, al conectarse, puede ver todos los datos de la tabla usuario (si no puede inicialmente, piensa por qué y soluciónalo).

--A partir de ahora, además, ten en cuenta con que usuario vas a hacer cada cosa. Para crear, cancelar o borrar políticas se hará desde un usuario con permisos de DBA (lo haremos así por facilidad). Para probarlas se hará con el nuevo usuario que hemos creado precisamente para eso. En resumen, cada vez que se solicite llevar a cabo una acción, incluso si el enunciado no lo especifica, no debes dudar acerca de cuál es el usuario que ha de hacerlo. Si dudas, pregunta al profesor.

--Recuerda también que siempre que creemos usuarios de prueba será asignándole los permisos MÍNIMOS necesarios para lo que queremos hacer (ni uno más).

--Añadiremos la política (consulta las transparencias) a la tabla USUARIO (desde un usuario con el role de DBA).  Y después comprobaremos que ocurre después de añadir la política. Una aclaración, al añadir una política, ésta se encuentra activa por defecto.

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
INSERT INTO USUARIOS VALUES (1, 'Juan Pérez', 'juan@email.com', 'PEPE');
INSERT INTO USUARIOS VALUES (2, 'Ana Gómez', 'ana@email.com', 'PLYTIX');

--Si en algún momento necesitas desactivar la política puedes usar:

begin

 DBMS_RLS.ENABLE_POLICY (        object_schema=>'el_nombre_del_esquema_en_el_que_está_la_tabla',    object_name=>'el_nombre_de_tu_tabla',

policy_name=>'nombre_politica', enable=>false);

end;

--Si te has equivocado y quieres borrar y volver a crear la política:

begin

dbms_rls.drop_policy (

  object_schema=>'el_esquema',

  object_name=>'la_tabla',

  policy_name=>'el_nombre_de_la_politica' );

end;

--10.  ¿Qué ocurre cuando nos conectamos con ese usuario existente en la tabla USUARIO y realizamos un select de todo? ¿Y cuándo lo hace el propietario de la tabla?
SELECT * FROM PLYTIX.USUARIOS; --EN PEPE
--SOLO VE SU FILA

--11. Utilizando VPD, también podemos aplicar políticas sobre columnas, en lugar de sobre vistas o tablas enteras. Continuando con nuestro ejemplo, imaginemos que queremos permitir a estos usuarios consultar todos los datos de la tabla excepto cuando también se solicita una columna determinada (ej. Telefono), en cuyo caso queremos que se muestren sólo los datos del usuario. Investiga en la documentación la función que ya hemos utilizado del paquete dbms_rls para añadir una política nueva (dbms_rls.add_policy). ¿Qué cambios deberíamos hacer para lograr nuestro objetivo? Tip: Desactiva previamente la política anterior para no tener conflictos en los resultados. 

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
--12. ¿Qué desventajas pueden llegar a tener este tipo de control de acceso más específico? Si no encuentras la respuesta discútelo con el profesor.
--menor transparencia
--dificil de depurar

--13. A continuación se detallan los distintos tipos de usuarios que existirán en la BD. Para la correcta gestión de ellos se deberán crear los roles, usuarios, vistas, permisos, etc. que sean precisos. Se recomienda comenzar por el usuario Administrador porque resultará de utilidad para el resto de usuarios, roles y privilegios.

--Los usuarios o grupos de usuarios serán los siguientes:

--Administrador del Sistema: Tiene control total sobre todas las tablas y es responsable de la seguridad (TDE y VPD). Puede crear, modificar y eliminar cuentas, usuarios, productos, activos y planes
--Usuario Estándar: Puede ver y modificar su propia información en Usuario. Puede acceder a productos y activos de su cuenta y dar de alta estos elementos. Puede acceder a su Plan asociado.
--Gestor de Cuentas: Accede y administra la tabla Cuenta. Puede modificar los datos de las cuentas (Nombre, DirecciónFiscal, NIF, etc.). No tiene acceso a datos sensibles de Usuario (Email, Teléfono).
--Planificador de Servicios: Administra la tabla Plan y sus relaciones (Productos, Activos, CategoríasProducto, CategoríasActivos). Puede definir planes y modificar los elementos que los componen.
--Para  la mayoría de estos tipos de usuarios deberemos discriminar qué individuo es el que está trabajando, esto puede hacerse creando un usuario particular para cada uno de ellos o bien mantener un usuario común para cada grupo y añadiendo algún tipo de mecanismo que permita discriminar qué usuario es el que está conectado (por ejemplo controlando variables o el contexto de la sesión, usando tablas temporales basadas en sesiones -on commit preserve rows- que almacenen el identificador particular de la persona que está conectada, etc).



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

