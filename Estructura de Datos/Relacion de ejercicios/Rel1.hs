-- Relación de Ejercicios 1. Ejercicios resueltos: ..........
--
-------------------------------------------------------------------------------
import Test.QuickCheck


--1. Tres enteros positivos x, y, z constituyen una terna pitagórica si -----------------------------
--x2+y2=z2
--, es decir, si son los lados de un triángulo rectángulo.
--a) Define la función:

esTerna :: Integer -> Integer -> Integer -> Bool
esTerna x y z = x^2 + y^2 == z^2
               || x^2 + z^2 == y^2
               || y^2 + z^2 == x^2

 ----Pruebas:
-----esTerna 3 4 5  -- True 
-----esTerna 5 5 5  -- False 
-----esTerna 7 24 25 -- True
-----esTerna 2 2 3  -- False

--b) Es fácil demostrar que para cualesquiera x e y enteros positivos con x>y,
 --la terna (x2-y2, 2xy, x2+y2) es pitagórica. 
 --Usando esto, escribe una función terna que tome dos parámetros y devuelva una terna pitagórica. 
 --Por ejemplo:


--Main> terna 3 1
--(8,6,10)
--Main> esTerna 8 6 10
--True 

terna :: Integer -> Integer -> (Integer, Integer, Integer)
terna x y = (x^2 - y^2, 2 * x * y, x^2 + y^2)



--c) Lee y entiende la siguiente propiedad, para comprobar que todas las ternas generadas por la
--función terna son pitagóricas:
--p_ternas x y = x>0 && y>0 && x>y ==> esTerna l1 l2 h
--where
-- (l1,l2,h) = terna x y

p_ternas :: Integer -> Integer -> Property
p_ternas x y = x>0 && y>0 && x>y ==> esTerna l1 l2 h
            where 
                (l1,l2,h) = terna x y


--d) Comprueba esta propiedad usando QuickCheck (recuerda importar Test.QuickCheck al principio
--de tu programa y copiar la propiedad en tu fichero). Verás que la respuesta es parecida a:
--Main> quickCheck p_ternas  *** Gave up! Passed only 62 tests
--lo que indica que, aunque sólo se generaron 62 casos de pruebas con las condiciones precisas,
--todos estos los casos pasaron la prueba.

---- OK, passed 100 tests; 799 discarded.

--------------------------------------------------------------------------------------------------------------------

--2.-Define una función polimórfica
--intercambia :: (a,b) -> (b,a)
--que intercambie de posición los datos de la tupla:
--Main> intercambia (1,True) Main> intercambia ('X','Y')
--(True,1) ('Y','X')

intercambia :: (a, b) -> (b, a)
intercambia (x, y) = (y, x)


--3. Este ejercicio versa sobre ordenación de tuplas.


--a) Define una función sobrecargada para tipos con orden
--ordena2 :: Ord a => (a,a) -> (a,a)
--que tome una tupla con dos valores del mismo tipo y la devuelva ordenada de menor a mayor:
--Main> ordena2 (10,3) Main> ordena2 ('a','z')
--(3,10) ('a','z')
--Copia en tu fichero las siguientes propiedades relativas a la función ordena2:
--p1_ordena2 x y = enOrden (ordena2 (x,y))
--where enOrden (x,y) = x<=y
--p2_ordena2 x y = mismosElementos (x,y) (ordena2 (x,y))
--where
-- mismosElementos (x,y) (z,v) = (x==z && y==v) || (x==v && y==z)
--(o, alternativamente, (x,y)==(z,v)||(x,y)==(v,z))
--Entiende lo que cada una significa, y compruébalas usando QuickCheck.

ordena2 :: Ord a => (a,a) -> (a,a)
ordena2 (x,y)
        | x <= y = (x,y)
        | otherwise = (y,x)

p1_ordena2 :: Ord a => a -> a -> Bool
p1_ordena2 x y = enOrden (ordena2 (x, y))
    where enOrden (x,y) = x<=y
--quickCheck p1_ordena2
--OK, passed 100 tests.


p2_ordena2 :: Ord a => a -> a -> Bool
p2_ordena2 x y = mismosElementos (x, y) (ordena2 (x, y))
  where 
    mismosElementos (x, y) (z, v) = (x == z && y == v) || (x == v && y == z)
--OK, passed 100 tests.


--b) Define una función sobrecargada para tipos con orden
--ordena3 :: Ord a => (a,a,a) -> (a,a,a)
--que tome una tupla con tres valores del mismo tipo y la devuelva ordenada, con los elementos de
--menor a mayor:
--Main> ordena3 (10,3,7)
--(3,7,10)

ordena3 :: Ord a => (a,a,a) -> (a,a,a)
ordena3 (x,y,z)
            | x>y && x>z && y>z = (z,y,x)
            | x>y && x>z && z>y = (y,z,x)
            | x<y && x>z && y>z = (z,x,y)
            | x<y && x<z && y>z = (x,z,y)
            | x>y && x<z && y<z = (y,x,z)
            | x<y && x<z && y<z = (x,y,z)
            | otherwise = (x,y,z)



--c) Escribe propiedades análogas a las del apartado anterior pero para esta función, y compruébalas
--usando QuickCheck.

p1_ordena3 :: Ord a => a -> a -> a -> Bool
p1_ordena3 x y z = enOrden( ordena3 (x,y,z))
    where enOrden (x,y,z)= x<=y && y<=z
-- OK, passed 100 tests.
p2_ordena3 :: Ord a=> a -> a -> a -> Bool
p2_ordena3 x y z = mismosElementos (x, y, z) (ordena3(x,y,z))
    where mismosElementos (x,y,z) (v,m,t)= (x==v && y==m && z==t)
                                        || (x==v && y==t && z==m)
                                        || (x==m && y==v && z==t)
                                        || (x==m && y==t && z==v)
                                        || (x==t && y==m && z==v)
                                        || (x==t && y==v && z==m)
--OK, passed 100 tests.

---------------------------------------------------------------------------------------------------------

--4. Aunque ya existe una función predefinida (max :: Ord a => a -> a -> a) para calcular el
--máximo de dos valores, el objetivo de este ejercicio es que definas tu propia versión de dicha
--función.


--a) Como no está permitido redefinir una función predefinida, define una nueva y llámala max2 ::
--Ord a => a -> a -> a de forma que satisfaga:
--Main> 10 `max2` 7 Main> max2 'a' 'z'
--10 'z'

max2 :: Ord a => a -> a -> a
max2 x y 
        | x>y = x
        |otherwise = y


--b) Define las siguientes propiedades que debería verificar tu función max2 y compruébalas con
--QuickCheck (recuerda importar Test.QuickCheck al principio de tu programa):
--i. p1_max2: el máximo de dos números x e y coincide o bien con x o bien con y.
--ii. p2_max2: el máximo de x e y es mayor o igual que x , así como mayor o igual que y.
--iii. p3_max2: si x es mayor o igual que y, entonces el máximo de x e y es x.
--iv. p4_max2: si y es mayor o igual que x, entonces el máximo de x e y es y. 

----i. p1_max2: el máximo de dos números x e y coincide o bien con x o bien con y.
p1_max2 :: Ord a => a -> a -> Bool
p1_max2 x y = coincide x y (max2 x y)
    where coincide x y z = x==z || y==z
--OK, passed 100 tests.

--ii. p2_max2: el máximo de x e y es mayor o igual que x , así como mayor o igual que y.
p2_max2 :: Ord a => a -> a -> Bool
p2_max2 x y = mayig x y (max2 x y)
    where mayig x y z = (x==z || z>x) && (y==z ||z>y)
--OK, passed 100 tests.

--iii. p3_max2: si x es mayor o igual que y, entonces el máximo de x e y es x.

p3_max2 :: Ord a => a -> a -> Bool
p3_max2 x y = mayig x y (max2 x y)
    where mayig x y z = (x>y||x==y)&&(z==x)
--OK, passed 100 tests.

--iv. p4_max2: si y es mayor o igual que x, entonces el máximo de x e y es y. 
p4_max2 :: Ord a => a -> a -> Bool
p4_max2 x y = mayig x y (max2 x y)
    where mayig x y z =  (y>x||x==y)&&(z==y)
--OK, passed 100 tests.

--------------------------------------------------------------------------------------------------------------
--5. Define una función sobrecargada para tipos con orden
--entre :: Ord a => a -> (a,a) -> Bool
--que tome un valor x además de una tupla con dos valores (min,max) y compruebe si x pertenece al
--intervalo determinado por min y max, es decir, si x ∈ [min,max], devolviendo True o False según
--corresponda. Por ejemplo:
--Main> 5 `entre` (1,10) Main> entre 'z' ('a','d')
--True False

entre :: Ord a => a -> (a,a) -> Bool
entre x (y,z)= x==y || x==z


--------------------------------------------------------------------------------------------------------------

--6. Define una función sobrecargada para tipos con igualdad
--iguales3 :: Eq a => (a,a,a) -> Bool
--que tome una tupla con tres valores del mismo tipo y devuelva True si todos son iguales. Por
--ejemplo:
--Main> iguales3 ('z','a','z')
--False
--Main> iguales3 (5+1,6,2*3)
--True

iguales3 :: Eq a => (a,a,a) -> Bool
iguales3 (x,y,z)= x==y && x==z 


--------------------------------------------------------------------------------------------------------------

--7. Recuerda que el cociente y el resto de la división de enteros se corresponde con las funciones
--predefinidas div y mod.


--a) Define una función descomponer que, dada una cantidad positiva de segundos, devuelva la
--descomposición en horas, minutos y segundos en forma de tupla, de modo que los minutos y
--segundos de la tupla estén en el rango 0 a 59. Por ejemplo:

--descomponer 5000 -> (1,23,20) descomponer 100 -> (0,1,40)
--Para ello, completa la siguiente definición:
--type TotalSegundos = Integer
--type Horas = Integer
--type Minutos = Integer
--type Segundos = Integer
--descomponer :: TotalSegundos -> (Horas,Minutos,Segundos)
--descomponer x = (horas, minutos, segundos)
--where
-- horas = ...
-- ...
--b) Comprueba la corrección de tu función verificando con QuickCheck que cumple la siguiente
--propiedad:
--p_descomponer x = x>=0 ==> h*3600 + m*60 + s == x
-- && entre m (0,59) && entre s (0,59)
--where (h,m,s) = descomponer x