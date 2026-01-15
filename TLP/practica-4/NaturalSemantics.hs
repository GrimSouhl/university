{-|

Programming Languages
Fall 2025

Implementation of the Natural Semantics of the WHILE Language
with Blocks and Procedures (Static Scope)

-}

module NaturalSemantics where

import           Aexp
import           Bexp
import           State
import           While

{-

  WHILE has evolved into an imperative, block-structured programming
  language with static scope and parameterless procedures.

  Note the following two important details about memory management in WHILE.

  First, 'next' is a special location that refers to the "next free
  cell in the store". In our implementation of WHILE, 'next' is stored
  at location 0 of the store.

  Second, global variables are no longer allowed in WHILE. Accessing
  an undefined variable raises a runtime error. Therefore, the
  variable environment is a partial function. Similarly, accessing a
  non-allocated location raises a runtime error; thus, the store is a
  partial function.

-}

----------------------------------------------------------------------
-- Variable Declarations
----------------------------------------------------------------------

-- Locations

type Loc = Z

-- Variable environment

type EnvVar = Var -> Loc

-- Store

type Store = Loc -> Z

-- The register 'next' is actually stored at location 0 of the store:
-- 'sto next' refers to the first available cell in the store 'sto'

next :: Loc
next = 0

-- Rudimentary stack-based memory allocation
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

-- | Exercise 1.1 - Update envV and sto

-- Update the variable environment with a new binding envV [x -> l]
updateVarEnv :: EnvVar -> Var -> Loc -> EnvVar
updateVarEnv envV x l = \y -> if x == y then l else envV y

-- Update the store with a new binding sto [l -> v]
updateStore :: Store -> Loc -> Z -> Store
updateStore sto l v = \l' -> if l == l' then v else sto l'

-- | Exercise 1.2 - Natural semantics for variable declarations

-- Variable declaration configurations

data ConfigD = InterD DecVar EnvVar Store  -- <Dv, envV, sto>
             | FinalD EnvVar Store         -- (envV, sto)

-- Representation of the judgement <Dv, envV, sto> ->_D (envV, sto)

nsDecV :: ConfigD -> ConfigD

-- var x:= a
nsDecV (InterD (Dec x a decs) envV sto) =
  nsDecV (InterD decs envV' sto'')
  where
    l = sto next
    v = aVal a (stoState envV sto)
    envV' = updateVarEnv envV x l
    sto' = updateStore sto l v
    sto'' = updateStore sto' next (new l)

-- epsilon
nsDecV (InterD EndDec envV sto)       = FinalD envV sto

----------------------------------------------------------------------
-- Procedure Declarations
----------------------------------------------------------------------

-- Procedure environment (note this environment is not a function)

--                    p    s    snapshots    previous
--                    |    |     /     \        |
data EnvProc = EnvP Pname Stm EnvVar EnvProc EnvProc
             | EmptyEnvProc

-- | Exercise 2.1 - Update envP

-- Update the procedure environment envP
updP :: DecProc -> EnvVar -> EnvProc -> EnvProc
updP (Proc p s procs) envV envP = updP procs envV envP'
  where
    envP' = EnvP p s envV envP envP
updP EndProc _ envP             = envP

-- | Exercise 2.2 - look up procedure definitions

-- Look up procedure p
envProc :: EnvProc -> Pname -> (Stm, EnvVar, EnvProc)
envProc (EnvP q s envV envP envs) p
  | p == q    = (s, envV, envP)
  | otherwise = envProc envs p
envProc EmptyEnvProc p = error $ "undefined procedure " ++ p

----------------------------------------------------------------------
-- Natural Semantics of WHILE
----------------------------------------------------------------------

-- Representation of configurations of WHILE

data Config = Inter Stm Store  -- <S, sto>
            | Final Store      -- sto

-- Representation of the judgement  envV, envP |- <S, sto> -> sto'

nsStm :: EnvVar -> EnvProc -> Config -> Config

-- | Exercise 3.1

nsStm _ _ (Final sto) = Final sto
nsStm envV _ (Inter Skip sto) = Final sto
nsStm envV _ (Inter (Ass x a) sto) = Final (updateStore sto (envV x) (aVal a (stoState envV sto)))
nsStm envV envP (Inter (Comp s1 s2) sto) = nsStm envV envP (Inter s2 sto')
  where
    Final sto' = nsStm envV envP (Inter s1 sto)
nsStm envV envP (Inter (If b s1 s2) sto)
  | bVal b (stoState envV sto) = nsStm envV envP (Inter s1 sto)
  | otherwise                  = nsStm envV envP (Inter s2 sto)
nsStm envV envP (Inter (While b s) sto)
  | bVal b (stoState envV sto) = nsStm envV envP (Inter (While b s) sto')
  | otherwise                  = Final sto
  where
    Final sto' = nsStm envV envP (Inter s sto)
nsStm envV envP (Inter (Block decV decP s) sto) = Final sto''
  where
    FinalD envV' sto' = nsDecV (InterD decV envV sto)
    envP' = updP decP envV' envP
    Final sto'' = nsStm envV' envP' (Inter s sto')
nsStm envV envP (Inter (Call p) sto) = Final sto'
  where
    (s, envV', envP') = envProc envP p
    envPRec = EnvP p s envV' envP' envP'
    Final sto' = nsStm envV' envPRec (Inter s sto)

-- Semantic function for Natural Semantics
sNs :: Stm -> Store -> Store
sNs s sto = sto'
   where
     Final sto' = nsStm initEnvV EmptyEnvProc (Inter s sto)
     initEnvV x = error $ "undefined variable " ++ x

----------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------

-- Convert (EnvVar, Store) into a plain State for Aexp/Bexp evaluation.
stoState :: EnvVar -> Store -> State
stoState envV sto x = sto (envV x)
