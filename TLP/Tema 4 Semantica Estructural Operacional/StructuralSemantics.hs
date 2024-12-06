{-|

Programming Languages
Fall 2023

Implementation of the Structural Operational Semantics of the WHILE Language

Author:

-}

module StructuralSemantics where

import           Aexp
import           Bexp
import           State
import           While

-- representation of configurations for While

data Config = Inter Stm State  -- <S, s>
            | Final State      -- s
            | Stuck Stm State  -- <S, s>

isFinal :: Config -> Bool
isFinal (Final _) = True
isFinal _         = False

isInter :: Config -> Bool
isInter (Inter _ _) = True
isInter _           = False

isStuck :: Config -> Bool
isStuck (Stuck _ _) = True
isStuck _           = False

-- representation of the transition relation <S, s> => gamma

sosStm :: Config -> Config

-- x := a

sosStm (Inter (Ass x a) s) = Final s'
    where 
        Final s' = Final (update s (x :=>: val))
        val = aVal a s

-- skip

sosStm (Inter Skip s) = Final s

-- s1; s2

sosStm (Inter (Comp ss1 ss2) s) = case sosStm (Inter ss1 s) of
    Final s'       -> Inter ss2 s'
    Inter ss1' s'  -> Inter (Comp ss1' ss2) s'
    Stuck ss1' s'  -> Stuck (Comp ss1' ss2) s'

-- if b then s1 else s2

-- if[tt]

sosStm (Inter (If b s1 s2) s) 
    | bVal b s = (Inter s1 s)

sosStm (Inter (If b s1 s2) s)
    | bVal (Neg(b)) s = (Inter s2 s)

-- while b do s

sosStm (Inter (While b ss) s) = (Inter (If b compW Skip) s)
    where 
        compW = Comp ss (While b ss)

-- repeat s until b

sosStm (Inter (Repeat ss b) s) = (Inter (Comp ss ifRep) s)
    where 
        ifRep = If b Skip (Repeat ss b)

-- for x a1 to a2 s

sosStm (Inter (For x a1 a2 ss) s) = (Inter (If cond next Skip) s)
    where 
        Final s' = Final (update s (x :=>: aVal1))
        cond = (Equ a1 a2)
        next = Comp ss (For x (N sVal1) (N sVal2) ss)
        aVal1 = aVal a1 s
        aVal2 = aVal a2 s
        sVal1 = show (aVal1 + 1)
        sVal2 = show aVal2

-- abort

sosStm (Inter Abort s) = Stuck Abort s

data Update =  Var :=>: Z

update :: State -> Update -> State
update s (x :=>: v) = (\y -> if y == x then v else s y)

