import Test.QuickCheck


--2. (Haskell) Implementa el TAD colas de prioridad usando una estructura recursiva lineal que no
---mantenga los elementos ordenados. La implementación insertará los elementos por la cabeza
--(como en un stack). y deben localizar el elemento mínimo en una estructura no
--ordenada y, respectivamente, eliminarlo o devolverlo (crea un módulo
--). Analiza la complejidad de estas
--operaciones.

--Tipo de datos:
data PriorityQueue a = Empty | Node a (PriorityQueue a) deriving (Show, Eq)

--insertará los elementos por la cabeza
--(como en un stack)

insert :: Ord a =>  a -> PriorityQueue a -> PriorityQueue a
insert nodo priorqueue = Node nodo priorqueue

--y deben localizar el elemento mínimo en una estructura no
--ordenada
--devuelve el min:
findMin :: Ord a => PriorityQueue a -> Maybe a
findMin Empty = error "no hay elementos"
findMin (Node n pq) = Just ( takemin n pq)
    where takemin n Empty = n
          takemin n (Node x pq) 
                | n < x = takemin n pq
                | otherwise = takemin x pq 

--y, respectivamente, eliminarlo 
--borra el min
borrarMin :: Ord a => PriorityQueue a -> PriorityQueue a 
borrarMin Empty = Empty 
borrarMin pq = borrarnode min pq 
    where 
        min = case findMin pq of 
            Just val ->val 
            Nothing -> error "no hay elementos"
        borrarnode _ Empty = Empty
        borrarnode minval (Node x pq')
            | x == minval = pq' 
            |otherwise = Node x (borrarnode minval pq')

