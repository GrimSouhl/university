-------------------------------------------------------------------------------
-- Student's name:
-- Student's group:
-- Identity number (DNI if Spanish/passport if Erasmus):
--
-- Data Structures. Grado en Informática. UMA.
-------------------------------------------------------------------------------

module DataStructures.Trie.DictionaryStringTrie(
    Trie()
  , empty
  , isEmpty
  , size
  , search
  , insert
  , strings
  , fromList
  , pretty
  , sampleTrie, sampleTrie1, sampleTrie2, sampleTrie3, sampleTrie4
  -- sizeValue, toTrie, childOf, update
  ) where

import qualified Control.DeepSeq as Deep
import Data.Maybe
import qualified DataStructures.Dictionary.AVLDictionary as D

data Trie a = Empty | Node (Maybe a) (D.Dictionary Char (Trie a)) deriving Show

-------------------------------------------------------------------------------
-- DO NOT WRITE ANY CODE ABOVE ------------------------------------------------
-------------------------------------------------------------------------------

-- | = Exercise a - empty
empty :: Trie a
empty = Empty
------------------------------------------------------------------------------------------------------------
-- | = Exercise b - isEmpty
isEmpty :: Trie a -> Bool
isEmpty Empty = True
isEmpty _     = False

------------------------------------------------------------------------------------------------------------
-- | = Exercise c - sizeValue
sizeValue :: Maybe a -> Int
sizeValue Nothing = 0
sizeValue _  = 1
------------------------------------------------------------------------------------------------------------
--(1 punto) Define la función size que, dado un Trie, devuelve el número de cadenas que almacena. 
--Observa que por cada cadena almacenada habrá un nodo final en el Trie. 
--Por ejemplo, para el Trie de la figura 1, la función size tiene que devolver 6.
-- | = Exercise d - size
size :: Trie a -> Int 
size Empty = 0
size (Node mb dictionario) = sizeValue mb + sum ( map size ( D.values dictionario))
--si es final sizevalue mb devolverá 1, si no 0, luego map size aplica a todos los hijos (D.values dictionario) 
--la funcion size recursivamente y vamos sacando la suma de los valores de los hijos
------------------------------------------------------------------------------------------------------------
--(0.5 puntos) Define la función toTrie que, dado un valor de tipo Maybe (Trie a), 
--devuelve Empty si el argumento es Nothing o que devuelve el Trie argumento si éste es de la forma Just.
-- | = Exercise e - toTrie
toTrie :: Maybe (Trie a) -> Trie a
toTrie Nothing = Empty
toTrie (Just x) = x  --devuelve el Trie

------------------------------------------------------------------------------------------------------------
--(0.5 puntos) Define la función childOf que, dados un carácter c y un Trie t, 
--devuelve el Trie asociado con el carácter c en el diccionario del nodo t.
-- Si t es un Trie vacío o si c no es una clave en el diccionario del nodo t, se devolverá Empty.
-- | = Exercise f - childOf
childOf :: Char -> Trie a -> Trie a
childOf _ Empty = Empty
childOf c (Node _ d) = toTrie (D.valueOf c d)


------------------------------------------------------------------------------------------------------------
--(1.5 puntos) Define la función search que, dados un String y un Trie t, devuelve el valor v asociado en el Trie 
--a dicha cadena como Just v. Si el Trie t no contiene dicha cadena devuelve Nothing.
-- | = Exercise g - search
search :: String -> Trie a -> Maybe a
search _ Empty = Nothing
search [] (Node mb _) = mb
search (x:xs) t = search xs (childOf x t)

------------------------------------------------------------------------------------------------------------
--(0.5 puntos) Define la función update que toma un Trie t, un carácter c y un Trie child. Si el Trie t es vacío 
--devuelve un Node no final cuyo diccionario incluye solamente una asociación entre el carácter c y el Trie child.
-- En otro caso devuelve un Node como t pero cuyo diccionario se habrá actualizado para que el carácter c quede asociado
-- con el Trie child.
-- | = Exercise h - update
update :: Trie a -> Char -> Trie a -> Trie a
update Empty car child = Node Nothing (D.insert car child D.empty)
update (Node r dict) car child = Node r (D.insert car child dict)

-- | = Exercise i - insert
insert :: String -> a -> Trie a -> Trie a
insert [] x Empty = Node (Just x) D.empty
insert [] x (Node _ d) = Node (Just x) d
insert (c:cs) x t = update t c (insert cs x (childOf c t))

-------------------------------------------------------------------------------
-- ONLY FOR PART TIME STUDENTS ------------------------------------------------
-------------------------------------------------------------------------------

-- | = Exercise e1 - strings
strings :: Trie a -> [String]
strings t = undefined

-- | = Exercise e2 - fromList
fromList :: [String] -> Trie Int
fromList xs = undefined

-------------------------------------------------------------------------------
-- DO NOT WRITE ANY CODE BELOW ------------------------------------------------
-------------------------------------------------------------------------------

pretty :: (Show a) => Trie a -> IO ()
pretty t = putStrLn (showsTrie t "")

showsTrie :: (Show a) => Trie a -> ShowS
showsTrie Empty       = shows "Empty"
showsTrie (Node mb d) = showString "Node " . showValue mb . showChar '\n' . aux 1 d
  where
    aux n d =
      foldr (.) id [ showString (replicate (6*n) ' ')
                      . showChar c
                      . showString " -> "
                      . showString "Node "
                      . showValue mb
                      . showChar '\n'
                      . aux (n+1) d'
                    | (c, Node mb d') <- D.keysValues d
                    ]

    showValue mb = maybe (shows mb) (const (showChar '(' . shows mb . showChar ')')) mb

instance (Eq a) => Eq (Trie a) where
  Empty     == Empty       = True
  Node mb d == Node mb' d' = mb == mb' && d == d'
  _         == _           = False

instance (Deep.NFData a) => Deep.NFData (Trie a) where
  rnf Empty       = ()
  rnf (Node mb d) = mb `Deep.deepseq` rnfDict d
    where
      rnfDict = D.foldKeysValues (\k v d -> k `Deep.deepseq` v `Deep.deepseq` v `Deep.deepseq` d) ()


sampleTrie :: Trie Integer
sampleTrie = n0
   -- bat -> 0  be -> 1  bed -> 2  cat -> 3  to -> 4  toe -> 5
   where
      children = foldr (uncurry D.insert) D.empty
      n0 = Node Nothing $ children [('b', n1), ('c', n6), ('t', n9)]
      n1 = Node Nothing $ children [('a', n2), ('e', n4)]
      n2 = Node Nothing $ children [('t', n3)]
      n3 = Node (Just 0) $ children []
      n4 = Node (Just 1) $ children [('d', n5)]
      n5 = Node (Just 2) $ children []
      n6 = Node Nothing $ children [('a', n7)]
      n7 = Node Nothing $ children [('t', n8)]
      n8 = Node (Just 3) $ children []
      n9 = Node Nothing $ children [('o', n10)]
      n10 = Node (Just 4) $ children [('e', n11)]
      n11 = Node (Just 5) $ children []

sampleTrie1 :: Trie Integer
sampleTrie1 = n0
   -- a -> 3  b -> 2  c -> 1
   where
      children = foldr (uncurry D.insert) D.empty
      n0 = Node Nothing $ children [('a', n1), ('b', n2), ('c', n3)]
      n1 = Node (Just 3) $ children []
      n2 = Node (Just 2) $ children []
      n3 = Node (Just 1) $ children []

sampleTrie2 :: Trie Integer
sampleTrie2 = n0
   -- a -> 1  ab -> 2  abc -> 3  abd -> 4  acdef -> 5
   where
      children = foldr (uncurry D.insert) D.empty
      n0 = Node Nothing $ children [('a', n1)]
      n1 = Node (Just 1) $ children [('b', n2), ('c', n5)]
      n2 = Node (Just 2) $ children [('c', n3), ('d', n4)]
      n3 = Node (Just 3) $ children []
      n4 = Node (Just 4) $ children []
      n5 = Node Nothing $ children [('d', n6)]
      n6 = Node Nothing $ children [('e', n7)]
      n7 = Node Nothing $ children [('f', n8)]
      n8 = Node (Just 5) $ children []

sampleTrie3 :: Trie Integer
sampleTrie3 = n0
   -- abcd -> 1
   where
      children = foldr (uncurry D.insert) D.empty
      n0 = Node Nothing $ children [('a', n1)]
      n1 = Node Nothing $ children [('b', n2)]
      n2 = Node Nothing $ children [('c', n3)]
      n3 = Node Nothing $ children [('d', n4)]
      n4 = Node (Just 1) $ children []

sampleTrie4 :: Trie Integer
sampleTrie4 = n0
   -- abcd -> 1  def -> 2
   where
      children = foldr (uncurry D.insert) D.empty
      n0 = Node Nothing $ children [('a', n1), ('d', n5)]
      n1 = Node Nothing $ children [('b', n2)]
      n2 = Node Nothing $ children [('c', n3)]
      n3 = Node Nothing $ children [('d', n4)]
      n4 = Node (Just 1) $ children []
      n5 = Node Nothing $ children [('e', n6)]
      n6 = Node Nothing $ children [('f', n7)]
      n7 = Node (Just 2) $ children []
