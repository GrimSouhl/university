library(tidyverse)

##Posit cheatsheets en la pagina de Posit de RStudio para atajos de librerias importantes

##quarto web -> queda guay


#comparacion<- 5>6
#comparacion

##para mirar ayuda de una funcion:
# > help("nombre_funcion")
#Fechas:

#Bank_Transaction_Fraud_Detection$Transaction_Date <- as.Date( Bank_Transaction_Fraud_Detection$Transaction_Date, )

#nombres a las posiciones de vector:

mivector <- c(1,2,3)
names(mivector) <- c("uno","dos","tres")

mivector[1]
mivector["dos"]

#matriz:
mimatriz <- matrix(NA, nrow=3, ncol=5)
mimatriz
help("matrix")

help("cbind")  #concatenar vectores en matriz

#listas:

milista <- list(5, "a", 1:10, c("a","b"), matrix(c(2,3,4,1,5,7) ,nrow=2, byrow=TRUE))

class(milista[[1]]) #numeric
class(milista[1]) #list

milista[[1]]*5
names(milista) <- c("l1","l2","l3","l4","l5")
class(milista$l5)

#clusters, sockets, forks ->mirar

#parSapply -> apply en paralelo
help("apply")

#dentro de tidyverse tenemos dplyr
help("dplyr")


#Variables aleatorias

#los graficos los haremos con ggplot2 
#diagramas de barras,historigramas,boxplots,puntos,etc...

#histograma-> poner tantos bins como raiz de n,el histograma representa la distribucion

#Sea X una variable aleatoria que viene dada por la funcion de probabilidad teorica:
#F(x) = P(X<=x)
#stat_ecdf  la probabilidad de la muestra de cumplir una condicion

#La funcion de densidad f(x) es tal que:
#F(x)=P(X<=x)= Integral[ f(x)dx ]    
#cumple: f(x)>0   Y   la integral en todo su dominio vale 1  ->funcion continua
#geom_density

#P(x-h<= X <= x+h) : la probabilidad de que x este en el radio de h (entre x-h y x+h)
#P(x-h<= X <= x+h) = Integral(x-h  x+h)[f(t)dx==2h*f(x)]
#^f(x)=(1/2*h)P(x-h<= X <= x+h)
#En conclusion hay que elegir un KERNEL(funcion continua) y un parámetro h
#contra mas grande el h mas suave se ven los datos, a menos h mas picos tiene


#diagrama de caja y bigotes


