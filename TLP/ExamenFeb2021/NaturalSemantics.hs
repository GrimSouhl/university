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

    Completa la definición semántica de la sentencia case:

    1. Primero, evaluamos la expresión aritmética `a`.
    2. Luego, comparamos el valor de `a` con las etiquetas de los casos en el orden dado (de arriba hacia abajo, y de izquierda a derecha en cada lista de etiquetas).
    3. Si encontramos un caso cuya etiqueta coincida con el valor de `a`, ejecutamos la sentencia asociada a ese caso.
    4. Si no encontramos ninguna coincidencia y existe un caso `default`, ejecutamos la sentencia asociada al `default`.
    5. Si no encontramos coincidencias y no hay un caso `default`, lanzamos una excepción (en este caso, usando `error`).

    La semántica se implementa como una búsqueda secuencial de la etiqueta de `a` en cada caso, y si no hay coincidencias, busca un caso `default`.

    Para definir esta semántica natural,
    creamos una función que evalúa el valor de `a`,
    recorre los casos, y ejecuta la sentencia correspondiente. 
    En caso de que no haya coincidencia, lanzamos un error.


-}

-- |----------------------------------------------------------------------
-- | Exercise 2.a
-- |----------------------------------------------------------------------

-- | Implement the Natural Semantics of the case statement.

nsStm (Inter (Case a lc) s) = case (findCase (aVal a s) lc) of
    Just st -> Final (nsStm' st s)  
    Nothing -> error "No matching case and no default found"  

--Encuentra el caso que coincide con el valor de `a`. Si no hay coincidencia, busca el caso `default`:
findCase :: Z -> LabelledStms -> Maybe Stm
findCase _ EndLabelledStms = Nothing  --no mas casos
findCase a (LabelledStm labels stm rest) 
    | a `elem` labels = Just stm  --coincidencia de etiqueata
    | otherwise = findCase a rest  --buscamos siguiente caso
findCase _ (Default stm) = Just stm  --default = ejecutamos sentencia

--Función auxiliar para ejecutar sentencias. Puede manejar compuestos y sentencias simples.
nsStm' :: Stm -> State -> State
nsStm' (Comp ss1 ss2) s = let Final s' = nsStm (Inter ss1 s) in nsStm' ss2 s'
nsStm' ss s = let Final s' = nsStm (Inter ss s) in s' 


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
