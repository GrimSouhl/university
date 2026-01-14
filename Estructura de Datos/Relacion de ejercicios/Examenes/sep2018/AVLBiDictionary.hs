-------------------------------------------------------------------------------
-- Apellidos, Nombre: 
-- Titulacion, Grupo: 
--
-- Estructuras de Datos. Grados en Informatica. UMA.
-------------------------------------------------------------------------------

module AVLBiDictionary( BiDictionary
                      , empty
                      , isEmpty
                      , size
                      , insert
                      , valueOf
                      , keyOf
                      , deleteByKey
                      , deleteByValue
                      , toBiDictionary
                      , compose
                      , isPermutation
                      , orbitOf
                      , cyclesOf
                      ) where

import qualified DataStructures.Dictionary.AVLDictionary as D
import qualified DataStructures.Set.BSTSet               as S

import           Data.List                               (intercalate, nub,
                                                          (\\))
import           Data.Maybe                              (fromJust, fromMaybe,
                                                          isJust)
import           Test.QuickCheck


data BiDictionary a b = Bi (D.Dictionary a b) (D.Dictionary b a)

-- | Exercise a. empty, isEmpty, size

empty :: (Ord a, Ord b) => BiDictionary a b
empty = Bi (D.empty) (D.empty)

isEmpty :: (Ord a, Ord b) => BiDictionary a b -> Bool
isEmpty (Bi dk dv) = (D.isEmpty dk) && (D.isEmpty dv)


size :: (Ord a, Ord b) => BiDictionary a b -> Int
size (Bi dk dv) 
  |isEmpty (Bi dk dv)  = 0
  |otherwise = D.size dk 

-- | Exercise b. insert

insert :: (Ord a, Ord b) => a -> b -> BiDictionary a b -> BiDictionary a b
insert k v (Bi dk dv) 
  | D.isDefinedAt k dk && D.isDefinedAt v dv = Bi (D.insert k v dk') (D.insert v k dv')
  | D.isDefinedAt k dk = Bi (D.insert k v dk) (D.insert v k dv')
  | D.isDefinedAt v dv = Bi (D.insert k v dk') (D.insert v k dv)
  |otherwise = Bi (D.insert k v dk) (D.insert v k dv)
  where
    oldV = fromJust (D.valueOf k dk)
    oldK = fromJust (D.valueOf v dv)
    dk' = if D.isDefinedAt v dv && oldK /= k then D.delete oldK dk else dk
    dv' = if D.isDefinedAt k dk && oldV /= v then D.delete oldV dv else dv

-- | Exercise c. valueOf

valueOf :: (Ord a, Ord b) => a -> BiDictionary a b -> Maybe b
valueOf k (Bi dk dv)
  |D.valueOf k dk == Nothing = Nothing 
  |otherwise = D.valueOf k dk 

-- | Exercise d. keyOf

keyOf :: (Ord a, Ord b) => b -> BiDictionary a b -> Maybe a
keyOf v (Bi dk dv) 
  | D.valueOf v dv == Nothing = Nothing
  |otherwise = D.valueOf v dv

-- | Exercise e. deleteByKey

deleteByKey :: (Ord a, Ord b) => a -> BiDictionary a b -> BiDictionary a b
deleteByKey k (Bi dk dv) 
  |D.isDefinedAt k dk = Bi dk' dv'
  |otherwise = Bi dk dv 
  where 
    v = fromJust (D.valueOf k dk)
    dk' = D.delete k dk
    dv' = D.delete v dv 

-- | Exercise f. deleteByValue

deleteByValue :: (Ord a, Ord b) => b -> BiDictionary a b -> BiDictionary a b
deleteByValue v (Bi dk dv) 
  |D.isDefinedAt v dv = Bi dk' dv'
  |otherwise = Bi dk dv 
  where 
    k = fromJust (D.valueOf v dv)
    dk' = D.delete k dk
    dv' = D.delete v dv 


-- | Exercise g. toBiDictionary

toBiDictionary :: (Ord a, Ord b) => D.Dictionary a b -> BiDictionary a b
toBiDictionary dk = Bi dk dv
  where
    kvs = D.keysValues dk 
    dv = foldr step D.empty kvs 
    step (k,v) acc 
      |D.isDefinedAt v acc = error "NO INYECTIVO"
      |otherwise = D.insert v k acc

-- | Exercise h. compose

compose :: (Ord a, Ord b, Ord c) => BiDictionary a b -> BiDictionary b c -> BiDictionary a c
compose (Bi dk1 dv1) (Bi dk2 dv2) = Bi dk3 dv3
  where
    (dk3,dv3) = foldr step (D.empty , D.empty) (D.keysValues dk1)
    step (a,b) (accK, accV)  =
      case D.valueOf b dk2 of
        Nothing -> (accK,accV)
        Just c -> (D.insert a c accK , D.insert c a accV)
    

-- | Exercise i. isPermutation

isPermutation :: Ord a => BiDictionary a a -> Bool
isPermutation (Bi dk dv) =
  D.size dk == D.size dv
    && setFromList (D.keys dk) == setFromList (D.values dk)
    && all (\(k, v) -> D.valueOf v dv == Just k) (D.keysValues dk)
  where
    setFromList = foldr S.insert S.empty


-- |------------------------------------------------------------------------


-- | Exercise j. orbitOf j) (1.5 puntos) Define la función orbitOf que recibe un BiDictionary que es permutación y una clave inicial y
--devuelve una lista con la órbita de la clave inicial en el BiDictionary. La órbita se obtiene de la siguiente forma:
--partiendo de la clave inicial, calcula su valor asociado. Usa este valor como clave y repite el proceso hasta que
--llegues a la clave inicial. En la figura anterior, la órbita de 1 en el BiDictionary es [1, 4, 5, 7]. Si el diccionario
--recibido como parámetro no es permutación se debe lanzar un error.

orbitOf :: Ord a => a -> BiDictionary a a -> [a]
orbitOf start bd 
  | not(isPermutation bd) = error "no es permutacion"
  |otherwise = start : go (next start)
    where
      next x = fromJust(valueOf x bd )
      go v 
        | v == start = []
        | otherwise = v : go (next v)

-- | Exercise k. cyclesOf
-- (1 punto) Define una función cyclesOf que dado un BiDictionary que es permutación obtiene todos sus
--ciclos (que no son más que las órbitas). Un posible algoritmo para calcularlas es el siguiente: Se parte de un conjunto
--S con los elementos del BiDictionary. Se calcula la órbita de un elemento cualquiera de S en el BiDictionary. A
--continuación, se eliminan de S todos los elementos que forman parte de la órbita calculada y se repite el proceso
--hasta que S quede vacío. En la figura anterior, los ciclos del BiDictionary son [[1, 4, 5, 7], [2, 3]] (el orden no tiene
--necesariamente por qué coincidir). Si el diccionario recibido como parámetro no es permutación se debe lanzar un
--error.
cyclesOf :: Ord a => BiDictionary a a -> [[a]]
cyclesOf bd@(Bi dk dv)
  | not (isPermutation bd) = error "no es permutacion"
  | otherwise = go (D.keys dk)
  where
    go [] = []
    go (x:xs) = orb : go (xs \\ orb)
      where
        orb = orbitOf x bd



-- |------------------------------------------------------------------------


instance (Show a, Show b) => Show (BiDictionary a b) where
  show (Bi dk dv)  = "BiDictionary(" ++ intercalate "," (aux (D.keysValues dk)) ++ ")"
                        ++ "(" ++ intercalate "," (aux (D.keysValues dv)) ++ ")"
   where
    aux kvs  = map (\(k,v) -> show k ++ "->" ++ show v) kvs
