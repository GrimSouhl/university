module DataStructures.SetChain.SetChain ( 
    SetChain 
    , empty 
    , isEmpty 
    , pendingTransactions 
    , add 
    , getEpoch 
    , size 
    , validate 
    --  
    , addAll     
    , fold 
    , toList 
    ) where 
 
import qualified DataStructures.Set.LinearSet as S 
import qualified DataStructures.Dictionary.AVLDictionary as D 
 
--                    Mempool            History                 Epoch 
data SetChain a = SC (S.Set a) (D.Dictionary Integer (S.Set a)) Integer 
 
-- ------------------------------- 
-- DO NOT MODIFY THE CODE ABOVE 
-- ------------------------------- 
 
-- * Exercise a) (0.25 puntos) Define la función empty que devuelve un SetChain
--vacío.
empty :: SetChain a 
empty = SC S.empty D.empty 0
 
-- * Exercise b) 0.25 puntos) Define la función isEmpty que dado un SetChain,
--devuelve True si está vacío o False en caso contrario.
--tenemos funciones de S y D que nos permiten saber si estan vacias
isEmpty :: SetChain a -> Bool 
isEmpty (SC set hist epoch) = S.isEmpty set && D.isEmpty hist && epoch == 0
 
-- * Exercise c) 1.5 puntos) Define la función getEpoch que dada una transacción y
--un SetChain, devuelve la época en la que se validó dicha
--transacción o -1 si no es una transacción validada.

getEpoch :: (Eq a) => a -> SetChain a -> Integer 
getEpoch transc_memo (SC set hist epoch) = recorrer(D.keysValues hist)
  where recorrer [] = -1
        recorrer ((key, value) : cola)
          |S.member transc_memo value =  key
          |otherwise = recorrer cola 
 
-- * Exercise d) (0.75 puntos) Define la función size que dado un SetChain,
--devuelve el número de transacciones validadas que contiene.

size :: SetChain a -> Int 
size (SC set hist epoch) = recorrer (D.keysValues hist)
  where recorrer [] = 0
        recorrer ((key, value) : cola) = S.size value + recorrer cola
 
-- * Exercise e) (0.25 puntos) Define la función pendingTransactions que dado un
--SetChain, devuelve True si hay transacciones pendientes de
--validación.

pendingTransactions :: SetChain a -> Bool 
pendingTransactions (SC set hist epoch) 
        |S.isEmpty set = False
        |otherwise = True   
 
-- * Exercise f) (0.5 puntos) Define la función add que dados una transacción y un
--SetChain, devuelve un nuevo SetChain como el proporcionado pero
--que, además, incluye la transacción dada como no validada.

add :: (Eq a) => a -> SetChain a -> SetChain a 
add transaccion (SC set hist epoch) = SC (S.insert transaccion set) hist epoch 
 
-- * Exercise g) (1.5 puntos) Define la función validate que, dado un SetChain,
--valida todas las transacciones no validadas. Este proceso incluye
---los siguientes casos: 
--1) Si no hay transacciones no validadas, el SetChain no se modifica. 
--2) Si alguna de las transacciones de mempool está en algún bloque de history, entonces se para el
--proceso de validación y se lanza un error con mensaje “transaction
--already validated”.
-- 3) En otro caso, hay que añadir a history una nueva asociación entre el nuevo bloque de transacciones validadas
--y la época en la que se ha realizado la validación. Además, hay
--que incrementar el valor de epochNum en 1 y dejar la mempool
--vacía.

validate :: (Eq a) => SetChain a -> SetChain a 
validate (SC set hist epoch)
        |S.isEmpty set = SC set hist epoch
        |existeTrans  = error "transaction already validated"
        |otherwise = let hist' = D.insert epoch set hist
                         epoch' = epoch + 1
                     in SC S.empty hist' epoch'
          where
            existeTrans = any (\x -> isValidated x hist) (S.toList set)
            isValidated x dict = any (\(_, setHist) -> S.member x setHist) (D.keysValues dict)
  
-- * Exercise h) (0.5 puntos) Define la función addAll que, dados una lista de
--transacciones y un SetChain, añade todas las transacciones de la
--lista al SetChain sin validar.

addAll :: (Eq a) => [a] -> SetChain a -> SetChain a 
addAll [] set = set
addAll (x:xs) set = addAll xs (add x set)

-- * Exercise i) (1.25 puntos) Define la función de plegado fold que, dados una
--función, un valor inicial y un SetChain, pliega, comenzando por el
--valor inicial y usando la función f de derecha a izquierda, las
--transacciones validadas de un SetChain.

fold :: (a -> b -> b) -> b -> SetChain a -> b 
fold f z (SC _ hist _) = foldr (\(_, set) acc -> S.fold f acc set) z (D.keysValues hist)

 
-- * Exercise j) (0.25 puntos) Define la función toList que, dado un SetChain,
--devuelve una lista que contiene todas las transacciones validadas.
--La implementación tiene que usar la función de plegado anterior.

toList :: SetChain a -> [a] 
toList = fold (:) []
 
-- ------------------------------- 
-- DO NOT MODIFY THE CODE BELOW 
-- ------------------------------- 
 
instance (Show a) => Show (SetChain a) where 
  show (SC s h e) = concat ["SetChain(", show s, ", ", show h, ", ", show e, ")"] 
 
instance (Eq a) => Eq (SetChain a) where 
  (SC m1 h1 e1) == (SC m2 h2 e2) = m1 == m2 && h1 == h2 && e1 == e2
