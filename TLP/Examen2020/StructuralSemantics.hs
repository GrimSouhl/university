import While20


--sosswap

sosStm (Inter (Swap x y) s) = Inter stm s''
where 
    Inter stm s' = sosStm
     (Inter ( (
        Comp (
            Comp (
                Ass z (V "y")
                )
            )
        (Ass y (V "z"))  
        (Ass x (V "z")))) s) z= "z"
    Final s'' = sosStm (Inter ( Ass z ( N ( s z))) s')

--forsos

sosStm (Inter (For s1 b s2 s3) s ) =
    Inter (If b (
        Comp (
            Comp(Comp (s1) (s3)) (s2)
            )
        (For Skip b s2 s3)) (Skip) ) s