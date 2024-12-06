{-|

Programming Languages
Fall 2023

Implementation of the Natural Semantics of the WHILE Language
with Blocks and Procedures (Static Scope)

Author:

-}

module NaturalSemantics where

import           Aexp
import           Bexp
import           State
import           While

{-

  WHILE is an imperative, block-structured programming language with
  static scope and parameterless procedures.

  Note two important differences with respect to the PROC language as
  defined by Nielson & Nielson.

  First, in PROC 'next' is a special location (a register) that refers
  to the next free cell in the store. In WHILE, 'next' is stored at
  the location 0 of the store.

  Second, in PROC global variables (i.e., undefined variables) are
  stored in location 0 of the store. This means that global variables
  are aliased: there is only one global variable. The advantage of
  this approach is that the variable environment is a total function.
  However, in WHILE global variables are not allowed. Accessing an
  undefined (global) variable raises a runtime error. Therefore, the
  variable environment is a partial function. Similarly, accessing a
  non-allocated location raises a runtime error, thus the store is a
  partial function.

-}

----------------------------------------------------------------------
-- Variable Declarations
----------------------------------------------------------------------

-- locations

type Loc = Z

-- variable environment

type EnvVar = Var -> Loc

-- store

type Store = Loc -> Z

-- the register 'next' is actually stored at location 0 of the store:
-- 'sto next' refers to the first available cell in the store 'sto'

next :: Loc
next = 0

-- rudimentary stack-based memory allocation
new :: Loc -> Loc
new l = l + 1

{-

   After processing the local variable declarations:

     var x:= 8;
     var y:= 5;

   we get the envV and sto shown below:

                        ┌───────┐
                      3 │       │◄──────┐
                        ├───────┤       │
                      2 │   5   │       │
      x ──► 1           ├───────┤       │
                      1 │   8   │       │
      y ──► 2           ├───────┤       │
                      0 │   3   ├───────┘
                        └───────┘  next

       envV                sto

-}

-- | Exercise 1.1 - update envV and sto

-- update a variable environment with a new binding envV [x -> l]
updateV :: EnvVar -> Var -> Loc -> EnvVar
updateV envV x l = (\y -> if y == x then l else envV y)

-- update a store with a new binding sto [l -> v]
updateS :: Store -> Loc -> Z -> Store
updateS sto l v = (\y -> if y == l then v else sto y)

-- | Exercise 1.2 - natural semantics for variable declarations

-- variable declaration configurations

data ConfigD = InterD DecVar EnvVar Store  -- <Dv, envV, store>
             | FinalD EnvVar Store         -- <envV, store>

nsDecV :: ConfigD -> ConfigD

-- var x:= a (no distingir)
nsDecV (InterD (Dec x a decs) envV store) = nsDecV (InterD decs envV' store'')
  where 
    nextVal = (store next)
    envV' = updateV envV x nextVal
    expVal = aVal a (\y -> store (envV y))
    store' = updateS store next (new nextVal)
    store'' = updateS store' nextVal expVal

-- epsilon
nsDecV (InterD EndDec envV store)         = FinalD envV store

----------------------------------------------------------------------
-- Procedure Declarations
----------------------------------------------------------------------

-- procedure environment (note this environment is not a function)

--                    p    s    snapshots    previous
--                    |    |     /     \        |
data EnvProc = EnvP Pname Stm EnvVar EnvProc EnvProc
             | EmptyEnvProc

-- | Exercise 2.1 - update envP

-- update the procedure environment envP
updP :: DecProc -> EnvVar -> EnvProc -> EnvProc
updP (Proc p s decs) envV envP = EnvP p s envV envP envP'
  where
    envP' = updP decs envV envP
updP EndProc _ envP = envP


-- | Exercise 2.2 - look up procedure definitions

-- lookup procedure p
envProc :: EnvProc -> Pname -> (Stm, EnvVar, EnvProc)
envProc (EnvP q s envV envP envs) p = if q == p then (s, envV, envP) else (envProc envs p)
envProc EmptyEnvProc p              = error("error")

----------------------------------------------------------------------
-- Natural Semantics for WHILE
----------------------------------------------------------------------

-- representation of configurations for WHILE

data Config = Inter Stm Store  -- <S, sto>
            | Final Store      -- sto

-- representation of the transition relation envV, envP |- <S, sto> -> sto'

nsStm :: EnvVar -> EnvProc -> Config -> Config

-- | Exercise 3.1

-- x := a
nsStm envV envP (Inter (Ass x a) sto) = Final sto'
  where 
    expA = aVal a (\y -> sto (env y))
    loc = env x
    sto' = updateS sto loc expA

-- Skip
nsStm envV envP (Inter Skip sto) = Final sto

-- Comp s1 s2
nsStm envV envP (Inter (Comp s1 s2) sto) = Final sto''
  where 
    Final sto' = nsStm envV envP (Inter s1 sto)
    Final sto'' = nsStm envV envP (Inter s2 sto')

-- If[tt]
nsStm envV envP (Inter (If b s1 s2) sto) 
  | bVal b (\y -> sto (envV y)) = nsStm envV envP (Inter s1 sto)

-- If[ff]
nsStm envV envP (Inter (If b s1 s2) sto) 
  | not (bVal b (\y -> sto (envV y))) = nsStm envV envP (Inter s2 sto)

-- While[tt]
nsStm envV envP (Inter (While b ss) sto) 
  | bVal b (\y -> sto (envV Y)) = nsStm envV envP (While b ss) sto'
    where 
      Final sto' = nsStm envV envP (Inter ss sto)

-- While [ff]
nsStm envV envP (Inter (While b ss) sto) 
  | not (bVal b (\y -> sto (envV y))) = Final sto

-- Block 
nsStm envV envP (Inter (Block decVar decProc ss) sto) = Final sto''
  where 
    Final envV' sto' = nsDecV (InterD ss envV sto)
    envP' = updP decVar envV' envP
    sto'' = (InterD (Dec x a decs) envV store) 



-- semantic function for Natural Semantics
sNs :: Stm -> Store -> Store
sNs s sto = sto'
   where
     Final sto' = nsStm initEnvV EmptyEnvProc (Inter s sto)
     initEnvV :: EnvVar
     initEnvV x = error $ "undefined variable " ++ x

-- case, estilo recursivad
