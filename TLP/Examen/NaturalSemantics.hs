-- -------------------------------------------------------------------
-- Natural Semantics for WHILE 2021.
-- Examen de Lenguajes de Programación. UMA.
-- 1 de febrero de 2021
--
-- Apellidos, Nombre:
-- -------------------------------------------------------------------

module NaturalSemantics where

-- En este fichero solo necesitas completar:
--
--   - 2.a la definición semántica de la sentencia case
--   - 2.a la implementación de la sentencia case
--
-- No modifiques el resto del código. Puedes probar
-- tu implementación con la función run, definida al final.

----------------------------------------------------------------------
-- NO MODIFICAR EL CODIGO DE ABAJO
----------------------------------------------------------------------

import           While21
import           While21Parser

updateState :: State -> Var -> Z -> State
updateState s x v y = if x == y then v else s y

-- representation of configurations for While

data Config = Inter Stm State  -- <S, s>
            | Final State      -- s

-- representation of the transition relation <S, s> -> s'

nsStm :: Config -> Config

-- x := a

nsStm (Inter (Ass x a) s) = Final (updateState s x (aVal a s))

-- skip

nsStm (Inter Skip s) = Final s

-- s1; s2

nsStm (Inter (Comp ss1 ss2) s) = Final s''
  where
    Final s'  = nsStm (Inter ss1 s)
    Final s'' = nsStm (Inter ss2 s')

-- if b then s1 else s2

nsStm (Inter (If b ss1 ss2) s)
  | bVal b s = Final s'
  where
    Final s' = nsStm (Inter ss1 s)

nsStm (Inter (If b ss1 ss2) s)
  | not(bVal b s) = Final s'
  where
    Final s' = nsStm (Inter ss2 s)

----------------------------------------------------------------------
-- NO MODIFICAR EL CODIGO DE ARRIBA
----------------------------------------------------------------------

-- case a of

-- |----------------------------------------------------------------------
-- | Exercise 2.a
-- |----------------------------------------------------------------------

-- | Define the Natural Semantics of the case statement.

{-

    Completa la definición semántica de la sentencia case.

-}

-- |----------------------------------------------------------------------
-- | Exercise 2.a
-- |----------------------------------------------------------------------

-- | Implement the Natural Semantics of the case statement.

nsStm _ = undefined

----------------------------------------------------------------------
-- NO MODIFICAR EL CODIGO DE ABAJO
----------------------------------------------------------------------

-- | Run the While program stored in filename and show final values of variables.
--   For example: run "TestCase.w"

run :: String -> IO()
run filename =
  do
     (_, vars, stm) <- parser filename
     let Final s = nsStm (Inter stm (const 0))
     print $ showState s vars
     where
       showState s = map (\ v -> v ++ "->" ++ show (s v))
