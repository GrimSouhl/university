module NaturalSemantics where

import While20

updateState :: State -> Var -> Z -> State
updateState s x z y = if x == y then z else s y

--configurations for while:

data Config 
    = Inter Stm State -- <Stm, State>
    | Final State   -- s 

--representtion of the transition relation <Stm, State> -> <Stm, State>

nsStm :: Config -> Config
--x:=a
nsStm Inter ( Ass x a) s) = Final ( updateState s x (aVal a s))

--skip
nsStm (Inter Skip s) = Final s 

--s1; s2

nsStm (Inter (Comp ss1 ss2) s) = Final s''
where
    Final s' = nsStm (Inter ss1 s)
    Final s'' = nsStm (Inter ss2 s')

--if b then s1 else s2
nsStm (Inter (If b ss1 ss2) s ) 
    |bVal b s = Final s'
    where
        Final s' = nsStm (Inter ss1 s)

nsStm (Inter (If b ss1 ss2) s)
    |not(bVal b s) = Final s'
    where
        Final s' = nsStm (Inter s1 s)
      
--sentencia SWAP:

nsStm (Inter ( Swap x y ) s = Final (updateState s1 y (s x))
where
    Final s1 = nsStm (Inter (Ass x (V y )) s)


--sentencia for:
--for true:
nsStm(Inter (For s1 b s2 s3)s) 
    |bVal b s = Final s''''
    where
        Final s' = nsStm (Inter s1 s)
        Final s'' = nsStm (Inter s3 s')
        Final s''' = nsStm (Inter s2 s'')
        Final s''''= nsStm (Inter (For Skip b s2 s3) s''')
--for false
nsStm(Inter (For s1 b s2 s3) s)
|not(bVal b s) = Final s'
where
    Final s' = Inter(s1 s)


--reduce:
reduce ->Aexp -> Aexp
--entero
reduce (N n ) = (N n)
--variable
reduce (V n) = (V n)
--suma
reduce (Add (N n1) (N n2)) = reduce (N (n1 + n2))
--resta
reduce (Sub(N n1) (N n2)) = reduce ( N (n1-n2))
--resta2
reduce (Sub a1 a2) = Sub (reduce a1') (reduce a2')
where 
    a1' =reduce a1
    a2' = reduce a2

--Multiplicacion
reduce (Mult (N n1) (N n2)) = reduce (N (n1*n2))
--mult 2
reduce (Mult a1 a2) = Mult (reduce a1') (reduce a2')
where
    a1'= reduce a1
    a2' = reduce a2








































