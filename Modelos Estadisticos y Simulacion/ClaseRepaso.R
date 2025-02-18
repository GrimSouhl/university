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

