library(tidyverse)
####TEMA 1 APUNTES
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
#h: bandwidth
#si asumo que mis datos son gaussianos, puedo asumir una determinada h

#Dos tipos de f, f gorrito y f teorica, la f teorica la asumimos para sacar la h junto con 
#la f gorrito
#---------------------
#Diagrama de caja y bigotes

#                  _____________
#                 /             \  <--Gaussiana
#         _______/               \
#        /         _____________       IQR = Q3 - Q1
#  _____          |     |      |
#Q1-1,5*2QR|------|     |      |---------| Q3+1,5*IQR
#                 |_____|______|
#                Q1      Q2    Q3  
x<-rnorm(20,mean=5,sd=1)
boxplot(x)

#Los diagramas de violín dependeran de la densidad kernel que se ponga


####TEMA 2:NUMEROS ALEATORIOS Y SIMULACIÓN: APUNTES

#Necesitamos vectores aleatorios
#numeros aleatorios puros: son los meramente aleatorios, sin reglas o planes
#cuasio-aleatorios
#pseudo-aleatorios <-los que vamos a usar nosotros
#ejemplo:
#U~Uniforme(a=0,b=1) 
#a:principio   b:final  los valores estan entre esos valores
#dentro de esa caja la prob de tener 0,2 0,5 es la misma (distribucion uniforme)

#generacion por congruencias:
#importante el tema de la semilla en generacion por congruencias
#para replicar modelos y poder obtener mismos resultados fijamos la semilla
#a,c,m se pueden no tocar,dejarlos como estan

#---------------------para variables discretas------------------------------------
#Distribucion uniforme en (0,1)
#P(U<=u)=P(u)

#definir variable aleatoria

#en variables continuas usamos intervalos

#probabilidad de Bernoulli:
#P(X=x) = p^x  *  (1-p)^1-x           x: 0 o 1        
#ejemplo:
#y~Bin(n,p)    n:numero de veces que repito la extraccion
#posibles resultados: (x1,x2) (1,1)  (1,0)  (0,1)  (0,0)
#P(y=0) = (1-p)^2                             [0 exitos]
#P(y=1) = p*(1-p) + (1-p)+p = 2*(p*(1-p))     [1 exito ]
#P(y=2) = p^2                                 [2 exitos]

#Simulacion de la distribucion geometrica:
#realizamos tantas pruebas independientes de bernoulli hasta que encontramos un éxito
#y es el número de fracasos hasta que obtenemos el primer éxito



#Simulacion de la Binomial Negativa: numero de fracasos hasta conseguir n exitos
#y=numero de fracasos hasta obtener n exitos

#-----^estas distribuciones son para variables discretas------------------------------------------------------------------------


#----------Ahora veremos como representar variables continuas

#queremos simular una Variable X que es continua 
#U~uniforme(0,1)   

#METODO DE LA INVERSA
#Si U~U(0,1)     X= F^(-1) (U) 
#EJEMPLO:
#nos tienen que dar la funcion de densidad,y la funcion acumulada
#la inversa:
#   y=1-e^(-Landam*x)
#   ln(e^Landam*x) = ln(1-y)
#   x = (ln(1-y))/Landam

lamba <-2
n<-10000
x_exp <- -log(1-runif(n))/lamba
x_exp

plot(density(rexp(n,rate=lamba)))
plot(density(x_exp))

#METODO DE ACEPTACIÓN-RECHAZO
#SIMULA UNA UNIFORME, TENEMOS QUE CONOCER LA F, LO Q SE HACE ES TIRAR NUMEROS ALEATORIOS AL CUADRADO Y VER SI ENTRAN DEBAJO DE LA DENSIDAD
#MENOS RESTRICTIVO QUE EL OTRO


#ESTRUCTURAS DE SIMULACIÓN
# Distribución multivariada: queremos generar un vector

normal_bivariada_independiente <- cbind(rnorm(1000), rnorm(1000,mean= 10, sd= 2))
cor(normal_bivariada_independiente)
voc(normal_bivariada_independiente)

#Normal bivariada
#ejemplo:
#PESO:
#ALTURA:
#M = sumatorio = (10 [300])
#                 ( 30, 20)
#Normal bibariada
#mu1- media primera columna
#mu2 media segunda columnasigma1 varianza de 1
#sigma de 2 la varianxa

x<-rnorm(1000)
y <-rexp(1000)

cov(x,y)
cov(y,x)

#Ejemplo:

library(MASS)
n <- 100
p<- 2

mu1 <- 0
mu2 <- 0
mu3 <- 10
mu4 <- 3
mu5 <- 12


sigma11<- 0.3
sigma12<-
sigma13<-
sigma14<-
  
  
#FUNCION EXPONENCIAL CUADRATICO
#K(X,X')
#ESOS DOS PARAMETROS NOS PERMETIRAN MODELAR LOS GAFICOS
# A MEDIDA QUE NOS ALEJAMOS DE LA DIAGONAL TENEMOS DATOS MAS PEQUEÑOS
#A MAS CERCA DE LA DIAGONAL MAYOR COVARIANZA, A MAS LEJOS MENOS COVARIANZA


##COMO FUNCIONARIAN LOS DATOS PARA QUE SE SIMULEN PARA QUE NOS VENGA BIEN PARA NUESTRO MODELO.
#MODELO DE REGRESION
#se le suele sumar un error para que la relacion no sea determinisa
#esta forma es mas dificilde controlar la correlacion ya que al ir cambiando datos se van cambiando los datos
  
#se puede ajustar un modelo a laparabola 