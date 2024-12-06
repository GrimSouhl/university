{-|

Programming Languages
Fall 2023

Implementation of the Natural Semantics of the WHILE Language

Author:

-}

module NaturalSemantics where

import           Aexp
import           Bexp
import           State
import           While

-- representation of configurations for WHILE

data Config = Inter Stm State  -- <S, s>
            | Final State      -- s

-- representation of the execution judgement <S, s> -> s'

nsStm :: Config -> Config

-- x := a

nsStm (Inter (Ass x a) s)      = Final (update s (x :=>: (aVal a s)))

-- skip

nsStm (Inter Skip s)           = Final s

-- s1; s2

nsStm (Inter (Comp ss1 ss2) s) = Final s''
  where 
    Final s'' = nsStm (Inter ss2 s')
    Final s' = nsStm (Inter ss1 s)
-- if b then s1 else s2

-- B[b]s = tt
nsStm (Inter (If b ss1 ss2) s)
  | bVal b s = nsStm (Inter ss1 s) 

-- B[b]s = ff
nsStm (Inter (If b ss1 ss2) s)
  | not(bVal b s) = nsStm (Inter ss1 s) 

-- while b do s

-- B[b]s = ff
nsStm (Inter (While b ss) s) 
  | not(bVal b s) = Final s 

-- B[b]s = tt
nsStm (Inter (While b ss) s)
  | bVal b s = nsStm (Inter (While b ss) s')
  where 
    Final s' = nsStm (Inter ss s)

-- repeat s until b

--repeat[tt]
nsStm (Inter (Repeat ss b) s)
  | bVal b s' = Final s'
    where 
      Final s' = nsStm (Inter ss s)

--repeat[ff]
nsStm (Inter (Repeat ss b) s)
  | bVal (Neg b) s' = nsStm (Inter (Repeat ss b) s')
    where 
      Final s' = nsStm (Inter ss s)

-- for x := a1 to a2 do s

-- for[ff]
nsStm (Inter (For x a1 a2 ss) s) 
  | bVal (Equ a2 a1) s = Final s''
    where 
      Final s'' = nsStm (Inter ss s')  
      Final s' = Final (update s (x :=>: ((s x) + 1)))
      
-- for[tt]
nsStm (Inter (For x a1 a2 ss) s) 
  | bVal (Leq a1 a2) s = Final s'''
    where
      Final s' = Final (update s (x :=>: val1))
      Final s'' = nsStm (Inter ss s')
      Final s''' = nsStm (Inter (For x (N sval1) (N sval2) ss) s'')
      val1 = aVal a1 s
      val2 = aVal a2 s
      sval1 = show (val1 + 1)
      sval2 = show val2

-- semantic function for natural semantics
sNs :: Stm -> State -> State
sNs ss s = s'
  where Final s' = nsStm (Inter ss s)

data Update = Var :=>: Z

update :: State -> Update -> State
update s (x :=>: v) = (\y -> if y == x then v else s y)


