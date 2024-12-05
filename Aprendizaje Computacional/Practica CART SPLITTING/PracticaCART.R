##librerias:------------------------------------------
library(ggplot2)



##creamos el dataframe---------------------------------------
data <- data.frame("x1"=c(2.771244718,1.728571309,3.678319846,3.961043357,2.999208922,
  7.497545867,9.00220326,7.444542326,10.12493903,6.642287351),
  "x2"=c(1.784783929,1.169761413,2.81281357,2.61995032,2.209014212,3.162953546,3.339047188,
  0.476683375,3.234550982,3.319983761),
  "y"=c(0,0,0,0,0,1,1,1,1,1))

#valIABLES:----------------------------------------------------------------------------
#MejorR1<- -1
#MejorR2<- -1

#S1<-0
#S2<-0
##Datos:
x1<- t(data[,"x1" , drop=FALSE])
x2<- t(data[,"x2" , drop=FALSE])
Y<-  t(data[,"y" , drop=FALSE])

#REPRESENTACION INICIAL:--------------------------------------------------------------------------

ggplot(data, aes(x = x1, y = x2)) +
  geom_point(aes(color = as.factor(y)), size = 2) +
  scale_color_manual(values = c("blue", "red")) +
  labs(x = "X1", y = "X2") +
  theme_minimal()

#-------------------------------------------------------------------------------------------------
##BOCETO DE FUNCIONES(IGNORAR):-------------------------------------------------------------------
##la media de las respuestas de la valiable de decisión en 
##la Región R:
##ymediasr <- function(x){
##  sum<-0
#  for(i in 1:10){
##   sum<-(sum+as.numeric(x[i]))
#  }
#  return(sum/length(x))
#}
#-------------------------------------------------------------------------------------------
##La valianza:
#calc_val <- function(x,y){
#  res<-0
#  for(i in 1:length(x)){
#    res<-(res+(as.numeric(x[i])-as.numeric(y))^2)
#  }
#  return(res)
#}
#--------------------------------------------------------------------------------------------


###APARTADO  A)


#---------------------------------------------------------------------------------------------
##FUNCION CART QUE NOS SACA EL VALOR QUE GARANTIZA LA SUMA MÍNIMA:
CART<- function(data, class_valiable, v= FALSE) {
  
  
  mejor_s <- Inf
  suma_min <- Inf
  mejor_val <- NA
  
  data <- data.frame(lapply(data, sort))
  labels <- names(data)[names(data) != class_valiable]
  
  size <- dim(data)[1] 

  for (val in labels) {
    
    sum <- Inf
    
    for (i in 2:(size - 1)) {
     
      aux_s <- data[[val]][i]
      
      ##--YR1-----------------
      yr1 <- data[[class_valiable]][data[[val]] < aux_s] 
      ##--YR2-----------------
      yr2 <- data[[class_valiable]][data[[val]] >= aux_s]
      ##SUMATORIO:
      suma_auxiliar <- sum((yr1 - mean(yr1))^2)+ sum((yr2 - mean(yr2))^2)
      
      if (suma_auxiliar <= sum) {
        sum <- suma_auxiliar
        s <- aux_s
      }#end if
      
      if (v) {
        print(
          sprintf(
            "valiable: %s = %f; valor: %f; suma min: %f", 
              val,aux_s,data[[class_valiable]][data[[val]] == aux_s],suma_auxiliar))
      }#end if
    }#end for-size
    
    if (sum<suma_min) {
      
      suma_min <- sum
      mejor_s <- s
      mejor_val <- val
      
    }#end if
  }#end for-labels
  
  ##R1
  r1 <- data[data[[mejor_val]] < mejor_s, ]
  ##R2
  r2 <- data[data[[mejor_val]] >= mejor_s, ]
  
  ##devolvemos el valor escogido y algunos datos importantes:
  return(list(R1 = r1, R2 = r2, value = mejor_s,mejor_val = mejor_val, sum = suma_min))

}#end function


datos_split<- CART(data,"y")
datos_split

###----RESULTADOS---------------------
##$R1                          
##x1        x2 y
##1 1.728571 0.4766834 0
##2 2.771245 1.1697614 0
##3 2.999209 1.7847839 0
##4 3.678320 2.2090142 0
##5 3.961043 2.6199503 0

##$R2
##x1       x2 y
##6   6.642287 2.812814 1
##7   7.444542 3.162954 1
##8   7.497546 3.234551 1
##9   9.002203 3.319984 1
##10 10.124939 3.339047 1

##$value
##[1] 6.642287  <-------------------------

##$mejor_val
##[1] "x1"       <-----------------------

##$sum
##[1] 0
####-------------------------------------

#--------------------------------------------------------------------------------------------


###APARTADO  B)


#---------------------------------------------------------------------------------------------
##PRIMERO SACAMOS LOS DOS SUBARBOLES SIMPLEMENTE APLICANDO EL ALGORITMO DE NUEVO:

ladoizquierdo<- CART(datos_split$R1,"y")
ladoizquierdo  
#-----RESULTADOS DEL LADO IZQUIERDO---------
#$R1
#x1        x2 y
#1 1.728571 0.4766834 0
#2 2.771245 1.1697614 0
#3 2.999209 1.7847839 0

#$R2
#x1       x2 y
#4 3.678320 2.209014 0
#5 3.961043 2.619950 0

#$value
#[1] 3.67832

#$mejor_val
#[1] "x1"

#$sum
#[1] 0
#--------------------------------

ladoderecho<- CART(datos_split$R2,"y")
ladoderecho
##---RESULTADOS DEL LADO DERECHO--------
#$R1
#x1       x2 y
#1 6.642287 2.812814 1
#2 7.444542 3.162954 1
#3 7.497546 3.234551 1

#$R2
#x1       x2 y
#4  9.002203 3.319984 1
#5 10.124939 3.339047 1

#$value
#[1] 9.002203

#$mejor_val
#[1] "x1"

#$sum
#[1] 0
##-----------------------------------------------

##Sacamos dataframe para tests:
datos_test <- data.frame(lapply(data, sort))

##Ahora dividimos los sub-árboles en derecha e izquierda:
##T1
ladoizquierdo_r1_test <- datos_test[datos_test$x1 < ladoizquierdo$value, ]
ladoizquierdo_r1_test

ladoizquierdo_r2_test <- datos_test[datos_test$x1 >= ladoizquierdo$value, ]
ladoizquierdo_r2_test

##T2
ladoderecho_r1_test <- datos_test[datos_test$x1 < ladoderecho$value, ]
ladoderecho_r1_test

ladoderecho_r2_test <- datos_test[datos_test$x1 >= ladoderecho$value, ]
ladoderecho_r1_test

##ACCURACY T1:
acc_izq_r1 <- sum(dim(ladoizquierdo_r1_test[ladoizquierdo_r1_test$y == 0, ])[1])
acc_izq_r1 

acc_izq_r2 <- sum(dim(ladoizquierdo_r2_test[ladoizquierdo_r2_test$y == 1, ])[1])
acc_izq_r2

##ACCURACY T2:
acc_der_r1 <- sum(dim(ladoderecho_r1_test[ladoderecho_r1_test$y == 0, ])[1])
acc_der_r1

acc_der_r2 <- sum(dim(ladoderecho_r2_test[ladoderecho_r2_test$y == 1, ])[1])
acc_der_r2

##VEMOS LAS ACCURACY DE CADA SUB-ÁRBOL:

##T1
acc_izq <- (acc_izq_r1 / dim(ladoizquierdo_r1_test)[1] +acc_izq_r2 / dim(ladoizquierdo_r2_test)[1]) / 2
acc_izq ##0.8571429 <-----más accuracy

##T2
acc_der <- (acc_der_r1 / dim(ladoderecho_r1_test)[1] +acc_der_r2 / dim(ladoderecho_r2_test)[1]) / 2
acc_der ##0.8125

##Nos quedamos con el sub-árbol T1 que es el más acertado ya que tiene el mayor accuracy/precisión

#--------------------------------------------------------------------------------------------


###APARTADO  c) Explica el criterio que seguirías pasa finalizar el árbol. Pon un ejemplo.


#---------------------------------------------------------------------------------------------


##Podríamos iterar recursivamente nuestra función hasta que este se quedara sin nodos/variables
#a los que operar/con los que comparar. Una vez llegado a ese punto podríamos decir que nuestro árbol estaría finalizado
