-------------------------------------------------------------------------------
-- Dictionaries implemented by using AVL Trees
--
-- Data Structures. Grado en Informática. UMA.
-- Pepe Gallardo, 2012
-------------------------------------------------------------------------------

module DataStructures.Dictionary.AVLDictionary
  ( Dictionary
  , empty
  , isEmpty
  , size
  , insert
  , updateOrInsert
  , valueOf
  , isDefinedAt
  , delete

  , keys
  , values
  , keysValues

  , foldKeys
  , foldValues
  , foldKeysValues
  ) where

import Data.Function(on)
import Data.List(intercalate)
import Data.Maybe(isJust)
import Test.QuickCheck
--import qualified SearchTree.AVL as T
--import qualified AVL as T
import qualified DataStructures.SearchTree.AVL as T


data Rel a b  = a :-> b

key :: Rel a b -> a
key (k :-> _)  = k

value :: Rel a b -> b
value (_ :-> v)  = v

withKey :: a -> Rel a b
withKey k  = k :-> undefined

-- Relations are compared by using only their keys
instance (Eq a) => Eq (Rel a b) where
  (==)  = (==) `on` key

instance (Ord a) => Ord (Rel a b) where
  compare  = compare `on` key

newtype Dictionary a b  = D (T.AVL (Rel a b))

-- returns an empty dictionary
empty :: Dictionary a b
empty  = D T.empty

-- checks if dictionary is empty
isEmpty :: Dictionary a b -> Bool
isEmpty (D avl)  = T.isEmpty avl

-- returns number of associations in dictionary
size :: Dictionary a b -> Int
size (D avl)  = T.size avl

-- inserts a key and a value in dictionary. Replaces association if key was already included
insert :: (Ord a) => a -> b -> Dictionary a b -> Dictionary a b
insert k v (D avl)  = D (T.insert (k :-> v) avl)

-- Actualiza o inserta una clave-valor en el diccionario
updateOrInsert :: (Ord a) => a -> (b -> b) -> b -> Dictionary a b -> Dictionary a b
updateOrInsert k f v (D avl) = D (T.updateOrInsert (\(k :-> oldValue) -> k :-> f oldValue) (k :-> v) avl)

-- returns value v associated with a key as Just v or Nothing if key is not in dictionary
valueOf :: (Ord a) => a -> Dictionary a b -> Maybe b
valueOf k (D avl)  =
  case T.search (withKey k) avl of
    Nothing         -> Nothing
    Just (_ :-> v') -> Just v'

-- returns true if key is in dictionary
isDefinedAt :: (Ord a) => a -> Dictionary a b -> Bool
isDefinedAt k d  = isJust (valueOf k d)

-- deletes association with provided key from dictionary
delete :: (Ord a) => a -> Dictionary a b -> Dictionary a b
delete k (D avl)  = D (T.delete (withKey k) avl)

-- returns a list with all keys in dictionary
keys :: Dictionary a b -> [a]
keys (D avl)  = map key (T.inOrder avl)

-- returns a list with all values in dictionary
values :: Dictionary a b -> [b]          -- conjunto 1 conjunto 2
values (D avl)  = map value (T.inOrder avl)-- conjunto 1: 1,2    / conjunto 2= 4,6

-- returns a list with all keys and values in dictionary
keysValues :: Dictionary a b -> [(a,b)]
keysValues (D avl)  = map toTuple (T.inOrder avl)
 where toTuple (k :-> v) = (k,v)

-- folds keys in dictionary
foldKeys :: (a -> c -> c) -> c -> Dictionary a b -> c
foldKeys f z (D avl)  = T.foldInOrder (f . key) z avl

-- folds values in dictionary
foldValues :: (b -> c -> c) -> c -> Dictionary a b -> c
foldValues f z (D avl)  = T.foldInOrder (f . value) z avl

-- folds keys and values in dictionary
foldKeysValues :: (a -> b -> c -> c) -> c -> Dictionary a b -> c
foldKeysValues f z (D avl)  = T.foldInOrder (\(k :-> v) -> f k v) z avl

instance (Show a, Show b) => Show (Dictionary a b) where
  show (D avl)  = "AVLDictionary(" ++ intercalate "," (aux (T.inOrder avl)) ++ ")"
   where
    aux []             = []
    aux (x:->y : xys)  = (show x++"->"++show y) : aux xys

instance (Ord a, Arbitrary a, Arbitrary b) => Arbitrary (Dictionary a b) where
    arbitrary  = do
      kvs <- listOf arbitrary
      return (foldr (\(k,v) -> insert k v) empty kvs)

instance (Eq a, Eq b) => Eq (Dictionary a b) where
  d == d' = keysValues d == keysValues d'
