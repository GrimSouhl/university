-- -------------------------------------------------------------------
-- Examen de Lenguajes de Programación. UMA.
-- 14 de enero de 2025
--
-- Apellidos, Nombre:
-- Código PC:
-- -------------------------------------------------------------------

module NaturalSemantics where

import           Aexp
import           Bexp
import           OStream
import           State
import           While
import           WhileParser

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

-- |----------------------------------------------------------------------
-- | = Exercise 1 - variable declarations
-- |----------------------------------------------------------------------

-- | Exercise 1.a - update envV

-- update a variable environment with a new binding envV [x -> l]
updateV :: EnvVar -> Var -> Loc -> EnvVar
updateV envV x l = \ y -> if y==x then l else envV y
--Example
--Let's say you have an environment envV where:
--envV "a" returns 1
--envV "b" returns 2
--You want to update the environment so that "a" now maps to 3.
--Now, newEnvV is a new function:
--newEnvV "a" returns 3 (because we updated it).
--newEnvV "b" returns 2 (unchanged from the original environment).
--The lambda function \ y -> if y == x then l else envV y creates a new environment function that:
--Returns the new location l for the variable x.
--Returns the original location for all other variables.
--This way, you can update the environment without changing the original one.

-- | Exercise 1.b - update sto

-- update a store with a new binding sto [l -> v]
updateS :: Store -> Loc -> Z -> Store
updateS sto l v = \ y -> if l == y then v else sto y
--the same happens here, we use lambda to update 

-- variable declaration configurations

data ConfigD = InterD DecVar EnvVar Store  -- <Dv, envV, store>
             | FinalD EnvVar Store         -- <envV, store>

-- | Exercise 1.c - natural semantics for variable declarations

nsDecV :: ConfigD -> ConfigD
-- 1.-  var x := a
-- x: variable name
-- a: expression to be evaluated
-- decs: remaining declarations 
-- envV: the current enviroment
--store: the current store

--  Grammar:
--              <Dv, envV [x -> l], sto [l->v][next->new l]>->D(envV',sto')
--    [var ns] ____________________________________________________________
--               <var x:=a;  Dv, envV , sto> -> D(envV', sto')
--                  where v = A[[a]](sto . envV) and l = sto next 
nsDecV (InterD (Dec x a decs) envV store) = nsDecV (InterD decs envV' store')
  where
    l = store next 
    -- ^assign a new location on our store
    v = aVal a (store . envV)
    -- ^evaluate expression a using the enviroment and store, returns v
    envV' = updateV envV x l 
    -- ^updates the enviroment with the new association x -> l 
    store' = updateS (updateS store l v) next (new l)
    -- ^updates the store to save the value v in the location l


--2.-  epsilon

--     Grammar:                 
--     [none ns]  <epsilon, envV, store> -> D(envV, sto)

--envV: current evniroment
--store: current store
nsDecV (InterD EndDec envV store) = FinalD envV store

----------------------------------------------------------------------
-- Procedure Declarations
----------------------------------------------------------------------

-- procedure environment (note this environment is not a function)

data EnvProc = EnvP Pname [Var] Stm EnvVar EnvProc
             | EmptyEnvProc

-- |----------------------------------------------------------------------
-- | = Exercise 2 - procedure declarations
-- |----------------------------------------------------------------------

-- | Exercise 2.a - update envP

--Grammar: (pag 61)
--updP(proc p is S; DP , envP ) = updP(DP , envP [p 7→ S])
--updP(ε, envP ) = envP

--data DecProc = Proc Pname [Var] Stm DecProc
--            | EndProc
--             deriving Show
-- update the procedure environment envP
updateP :: DecProc -> EnvVar -> EnvProc -> EnvProc
updateP (Proc p lista s procs) envV envP = updateP procs envV  (EnvP p lista s envV envP)
--p: procedure name
--lista: the list of variables
--s: the statement
--procs: the remaining procedure declarations
updateP EndProc envV envP = envP
--returns the enviroment



-- | Exercise 2.b - look up procedure definitions

-- lookup procedure p
--data EnvProc = EnvP Pname [Var] Stm EnvVar EnvProc
--             | EmptyEnvProc
envProc :: EnvProc -> Pname -> ([Var], Stm, EnvVar, EnvProc)
envProc (EnvP q lista s envV envP) p 
    | p == q = (lista, s, envV, envP)
    |otherwise = envProc envP p
envProc EmptyEnvProc p = error $ "undefined procedure " ++ p

----------------------------------------------------------------------
-- Natural Semantics for WHILE
----------------------------------------------------------------------

-- representation of configurations for WHILE

data Config = Inter OStream EnvVar EnvProc Stm Store  -- O, envV, envP |- <S, sto>
            | Final OStream Store                     -- O', sto'

-- representation of the execution judgement: O, envV, envP |- <S, sto> -> O', sto'

nsStm :: Config -> Config

-- |----------------------------------------------------------------------
-- | = Exercise 3. - implementation of statements (except for print, block, and call)
-- |----------------------------------------------------------------------

-- x:= a
--Grammar:
--[ass ns]  envV , envP ⊢ ⟨x:= a, sto⟩ → sto[l → v]
--            where  l = envV x and v = A[[a]](sto ◦ envV )
nsStm (Inter o envV envP (Ass x a) store) =  Final o store' 
    where
      l = envV x 
      v = aVal a (store . envV)
      store' = updateS store l v

-- skip
--Grammar:
-- [skip ns] envV , envP ⊢ ⟨skip, sto⟩ → sto
nsStm (Inter o envV envP Skip store) = Final o store


-- s1; s2
--Grammar:
--                 envV , envP ⊢ ⟨S1, sto⟩ → sto′ envV , envP ⊢ ⟨S2, sto′ ⟩ → sto′′
--    [comp ns]   _____________________________________________________________________
--                              envV , envP ⊢ ⟨S1; S2, sto⟩ → sto′′

nsStm (Inter o envV envP (Comp s1 s2) store) = Final o'' store''
    where
      Final o' store' = nsStm (Inter o envV envP s1 store)
      Final o'' store'' = nsStm (Inter o' envV envP s2 store')

-- if b then s1 else s2
--Grammar:
--                        envV , envP ⊢ ⟨S1, sto⟩ → sto′
--    [if tt ns]   ________________________________________________________-
--                      envV , envP ⊢ ⟨if b then S1 else S2, sto⟩ → sto′
--                      where:   B[[b]] (sto ◦ envV ) = tt

--                        envV , envP ⊢ ⟨S2, sto⟩ → sto′
nsStm (Inter o envV envP (If b s1 s2) store)
        | bVal b (store . envV) = Final o' store' 
          where
            Final o' store' = nsStm ( Inter o envV envP s1 store)

--   [if ff ns]   _______________________________________________________
--                     envV , envP ⊢ ⟨if b then S1 else S2, sto⟩ → sto′
--                      where:   B[[b]](sto ◦ envV ) = f
nsStm (Inter o envV envP (If b s1 s2) store)
        | not (bVal b (store . envV)) = Final o' store' 
          where
            Final o' store' = nsStm ( Inter o envV envP s2 store)

-- while b do s
--                    envV , env P ⊢ ⟨S, sto⟩ → sto′ envV , env P ⊢ ⟨while b do S, sto′⟩ → sto′′
--    [while tt ns ] ________________________________________________________________________________
--                    envV , env P ⊢ ⟨while b do S, sto⟩ → sto′′
--                      where  B[[b]](sto ◦ envV ) = tt
nsStm (Inter o envV envP (While b s1) store) 
        | bVal b (store . envV) = Final o'' store''
          where
            --we apply the statement
            Final o' store' = nsStm (Inter o envV envP s1 store)
            --then we return to the while loop 
            Final o'' store'' = nsStm (Inter o' envV envP (While b s1) store')

--    [while ff  ns ]   envV , envP ⊢ ⟨while b do S, sto⟩ → sto
--                      where  B[[b]](sto ◦ envV ) = f
nsStm (Inter o envV envP (While b s1) store) 
        | not (bVal b (store . envV)) = Final o store


-- |----------------------------------------------------------------------
-- | = Exercise 4. - 'print' statement
-- |----------------------------------------------------------------------

-- | Exercise 4.a - define the Natural Semantics of the 'print' statement.

{-
    [print ns a]  o, enV, envP -> <print a, sto> ->o' , sto 
      where o' = put (aVal a (sto . envV)) 0
    [print ns s]  o, envV, envP -> <print str, sto> -> o' , sto
      where o' = put str o
-}

-- | Exercise 4.b - implement the Natural Semantics of the 'print' statement.

-- print
{-
      [print ns a]  o, enV, envP -> <print a, sto> ->o' , sto 
          where o' = put (aVal a (sto . envV)) o
-}
nsStm (Inter os envV envP (Print (Exp a)) sto) = Final os' sto
  where 
    os' = put (show (aVal a (sto . envV))) os
{-
      [print ns s]  o, envV, envP -> <print str, sto> -> o' , sto
            where o' = put str o
-}
nsStm (Inter os envV envP (Print (Str s)) sto) = Final os' sto
  where 
    os' = put s os



-- |----------------------------------------------------------------------
-- | = Exercise 5. - 'block' statement
-- |----------------------------------------------------------------------

-- | Exercise 5.a - define the Natural Semantics of the 'block' statement.

{-
                      <Dv,envV,sto> -> D (envV' , sto')    envV',envP' |- <S, sto'> -> O', sto''
        [block ns] ____________________________________________________________________________________-
                        O, envV, envP |- <begin Dv Dp S end, sto> -> O', sto''
                  where
                    envP' = updateP Dp envV' envP
                    sto'' = updateS sto'' next (sto next)       

-}

-- | Exercise 5.b - implement the Natural Semantics of the 'block' statement.

-- block vars procs sto is the current store.

--os: current output.
--envV: current variable environment.
--envP: current procedure environment.
--dv: variable declarations.
--dp: procedure declarations.
--ss: sequence of statements.

nsStm (Inter os envV envP (Block dv dp ss) sto) = Final os' sto'''
  where
    FinalD envV' sto' = nsDecV (InterD dv envV sto)
    envP' = updateP dp envV' envP
    Final os' sto'' = nsStm (Inter os envV' envP' ss sto')
    sto''' = updateS sto'' next (sto next)


-- |----------------------------------------------------------------------
-- | = Exercise 6. - 'call' statement
-- |----------------------------------------------------------------------

-- | Exercise 6.a - define the Natural Semantics of the 'call' statement.

{-
                 envV'' , envP' [ p -> (vars, S, envV',envP)] |- <S,sto> -> sto' 
  [call ns] _________________________________________________________________________
                     O, envV, envP  |- <call p vars_p , sto> -> O' , sto'
                      where
                        envP p = (vars, S, envV', envP')
                        envV' = actualizar envV' vars envV vars_p

-}

-- | Exercise 6.b - implement the Natural Semantics of the 'call' statement.

-- call p(args)
nsStm (Inter os envV envP (Call p vars_p) sto) =  Final os' sto'
  where
    (vars, stm, envV', envP') = envProc envP p
    envP'' = EnvP p vars stm envV' envP'
    envV'' = actualizar envV' vars envV vars_p --update the variable enviroment
    Final os' sto' = nsStm (Inter os envV'' envP'' stm sto)

actualizar :: EnvVar -> [String] -> EnvVar -> [String] -> EnvVar
actualizar envV' [] _ [] = envV'
actualizar envV' [x] envV [y] = updateV envV' x (envV y)
actualizar envV' (x:xs) envV (y:ys) = actualizar (updateV envV' x (envV y)) xs envV ys

-- | Use the function 'run' below to execute the While programs in the directory 'Examples'
-- | to check your implementation  of the Natural Semantics. For example:
-- |
-- |  > run "Examples/Swap.w"

-- | Run the While program stored in filename and show the final content of the store
run :: FilePath ->  IO()
run filename =
  do
     (program, _, stm) <- parser filename
     let Final os store = nsStm (Inter nullOutputStream emptyEnvV EmptyEnvProc stm emptyStore)
     putStrLn $ "Program " ++ program ++ " finalized."
     printOutputStream os
     putStrLn ""
     putStr "Memory dump: "
     print $ showStore store
  where
      showStore sto = [ (l, v) | l <- [0..sto next - 1], let v = sto l ]
      emptyEnvV x = error $ "undefined variable " ++ x
      emptyStore l
         | l == next = 1
         | otherwise = error $ "undefined location " ++ show l
