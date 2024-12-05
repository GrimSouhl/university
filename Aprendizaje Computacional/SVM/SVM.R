# Importamos las Librerias necesarias
library (kernlab)
library(e1071)

# Creamos la funcion que dira que clase pertenece cada punto
print_clasificacion <- function (x, w, b) {
  if ((t (w) %*% x + b) >= 0)
  {
    print (x)
    print("Pertence a la clase: 1")
  }
  else
  {
    print (x)
    print("Pertence a la clase: -1")
  }
}

## APARTADO A 
#---------------------------------------------------------------------------
## A=[0,0] que pertenece a la clase Y=+1; B=[4,4] con clase Y=-1. 
##Clasificar los puntos [5,6] y [1,-4
# Creamos el conjunto de datos
dataA <- data.frame(
  x1 = c(0, 4),
  x2 = c(0, 4),
  y = c(1, -1)
)
# Indicamos que la columna y es la importante
dataA$y <- as.factor(dataA$y)

# Creamos el SVM con los datos del A con un kernel lineal
svmA <- svm(y~., dataA , kernel="linear")
plot(svmA,data=dataA)
#Vectores de soporte
vsA <- dataA[svmA$index,1:2]

# Calculamos los valores del kernel
x1=c(0,0)
x2=c(4,4)
KAA=t (x1) %*% x1
KAB=t (x1) %*% x2
KBB=t (x2) %*% x2


# Vector de pesos normal al hiperplano (W)
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange
wA <- crossprod(as.matrix(vsA), svmA$coefs)

# Calcular ancho del canal
widthA = 2/(sqrt(sum((wA)^2)))

# Calcular vector B
bA <- -svmA$rho

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo
# y negativo
Withd=2 / (sum (sqrt ((wA)^2)))
paste(c("[",wA,"]' * x + [",bA,"] = 0"), collapse=" ")
paste(c("[",wA,"]' * x + [",bA,"] = 1"), collapse=" ")
paste(c("[",wA,"]' * x + [",bA,"] = -1"), collapse=" ")

# Determinamos a la clase que pertenece cada uno
print_clasificacion(c(5, 6),wA, bA)
print_clasificacion(c(1, -4),wA, bA)


##APARTADO B---------------------------------------------------------
##A=[2,0] que pertenece a la clase Y=+1; B=[0,0] y C=[1,1] con clase 
##Y=-1. Clasificar los puntos [5,6] y [1,-4]

# vectores soporte
A = c(2,0)
B = c(0,0)
C = c(1,1)

##DISTANCIAS----------------------------------------------------
#Distancia entre A y B
distanceAB = sqrt((A[1]-B[1])^2 + (A[2]-B[2])^2)
#Distancia entre A y C
distanceAC = sqrt((A[1]-C[1])^2 + (A[2]-C[2])^2) 
#A y B son los vectores soporte al tener menor distancia
#----------------------------------------------------------------
#Creamos el conjunto de datos con eso en mente:
dataB <- data.frame(
  x1 = c(2, 0, 1),
  x2 = c(0, 0, 1),
  y = c(1, -1, -1)
)
# Calculamos los valores del kernel sabiendo que A y B son los vectores soporte
KAA=t (A) %*% A
KAB=t (A) %*% B
KBB=t (B) %*% B
# Indicamos que la columna y es la importante
dataB$y <- as.factor(dataB$y)
# Creamos el SVM con los datos del B con un kernel lineal
svmB <- svm(y~., dataB, kernel="linear")
#Vectores de soporte
vsB <- dataB[svmB$index,1:2]
# Vector de pesos normal al hiperplano (W)
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange
wB <- crossprod(as.matrix(vsB), svmB$coefs)
# Calcular ancho del canal
widthB = 2/(sqrt(sum((wB)^2)))
# Calcular vector B
bB <- -svmB$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo
# y negativo
Withd=2 / (sum (sqrt ((wB)^2)))
paste(c("[",wB,"]' * x + [",bB,"] = 0"), collapse=" ")
paste(c("[",wB,"]' * x + [",bB,"] = 1"), collapse=" ")
paste(c("[",wB,"]' * x + [",bB,"] = -1"), collapse=" ")
# Determinamos a la clase que pertenece cada uno
print_clasificacion(c(5, 6),wB, bB)
print_clasificacion(c(1, -4),wB, bB)



## APARTADO c
#-------------------------------------------------------
## [2, 2], [2, -2], [-2, -2], [-2, 2] [2, 2], [2, -2], [-2, -2], [-2, 2] que
##pertenece a la clase Y=+1; [1, 1], [1, -1], [-1, -1], [-1, 1] que pertenece a
##la clase Y=+1. Encuentra puntos que clasifiquen positiva y
##negativamente

x1 = c(2,2)
x2 = c(2,-2)
x3 = c(-2,-2)
x4 = c(-2,2)
y1 = c(1,1)
y2 = c(1,-1)
y3 = c(-1,-1)
y4 = c(-1,1)


##DISTANCIAS----------------------------------------------------
#Distancia entre X1 y Y1
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2)

#Distancia entre X1 y Y2
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2)

#Distancia entre X1 y Y3
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2)

#Distancia entre X1 y Y4
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2)

#Distancia entre X2 y Y1
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2)

#Distancia entre X2 y Y2
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2) 

#Distancia entre X2 y Y3
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2)

#Distancia entre X2 y Y4
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2)

#Distancia entre X3 y Y1
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2)

#Distancia entre X3 y Y2
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2)

#Distancia entre X3 y Y3
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2)

#Distancia entre X3 y Y4
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2)

#Distancia entre X4 y Y1
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2)

#Distancia entre X4 y Y2
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2)

#Distancia entre X4 y Y3
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2)

#Distancia entre X4 y Y4
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2)
##-------------------------------------------------------------------
#A y B son los vectores soporte al tener menor distancia

#Calculamos los valores del kernel:
KAA=t (x1) %*% x1
KAB=t (x1) %*% y1 
KBB=t (y1) %*% y1

#Conjunto de datos:
dataC <- data.frame(
  
  x1 = c(2, 2, -2, -2, 1, 1, -1, -1),
  x2 = c(2, -2, -2, 2, 1, -1, -1, 1),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
  
)

# Indicamos que la columna y es la importante
dataC$y <- as.factor(dataC$y)

# Creamos el SVM con los datos del C con un kernel lineal
svmC <- svm(y~., dataC, kernel="linear")

#Vectores de soporte
vsC <- dataC[svmC$index,1:2]

#Vector de pesos normal al hiperplano (W)
#CrosProduct entre los vectores soporte y el cof. de Lagrange
wC <- crossprod(as.matrix(vsC), svmC$coefs)

#ancho del canal:
widthC = 2/(sqrt(sum((wC)^2)))

#Calcular vector B:
bC <- -svmC$rho

#Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo:
Withd=2 / (sum (sqrt ((wC)^2)))
paste(c("[",wC,"]' * x + [",bC,"] = 0"), collapse=" ") 


## APARTADO D
#-------------------------------------------------------------------
# . Repite el caso anterior usando la función de transformación


X = c(2,2,2,-2,-2,-2,-2,2)
Y = c(1,1,1,-1,-1,-1,-1,1)
i = 1

while (i<8){
  if(sqrt(X[i]^2 + X[i+1]^2) > 2){
    temp1 = X[i]
    temp2 = X[i+1]
    X[i] = 4 - temp2 + abs(temp1-temp2)
    X[i+1] = 4 - temp1 + abs(temp1-temp2)
  }
  
  if(sqrt(Y[i]^2 + Y[i+1]^2) > 2){
    temp1 = Y[i]
    temp2 = Y[i+1]
    Y[i] = 4 - temp2 + abs(temp1-temp2)
    Y[i+1] = 4 - temp1 + abs(temp1-temp2)
  }
  i = i+2
}
##--------------
x1 = c(X[1],X[2])
x2 = c(X[3],X[4])
x3 = c(X[5],X[6])
x4 = c(X[7],X[8])
y1 = c(Y[1],Y[2])
y2 = c(Y[3],Y[4])
y3 = c(Y[5],Y[6])
y4 = c(Y[7],Y[8])
##--------------
##DISTANCIAS----------------------------------------------------
#Distancia entre X1 y Y1
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2)
#Distancia entre X1 y Y2
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2)
#Distancia entre X1 y Y3
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2)
#Distancia entre X1 y Y4
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2)
#Distancia entre X2 y Y1
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2)
#Distancia entre X2 y Y2
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2)
#Distancia entre X2 y Y3
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2)
#Distancia entre X2 y Y4
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2)
#Distancia entre X3 y Y1
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2)
#Distancia entre X3 y Y2
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2)
#Distancia entre X3 y Y3 
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2)
#Distancia entre X3 y Y4
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2)
#Distancia entre X4 y Y1
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2)
#Distancia entre X4 y Y2
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2)
#Distancia entre X4 y Y3
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2)
#Distancia entre X4 y Y4
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2)
##----------------------------------------------------------------
#A y B son los vectores soporte al tener menor distancia

#Calculamos los valores del kernel:

KAA=t (x1) %*% x1
KAB=t (x1) %*% y1
KBB=t (y1) %*% y1

#Creamos el conjunto de datos:

datad <- data.frame(
  
  x1 = c(2, 10, 6, 6, 1, 1, -1, -1),
  x2 = c(2, 6, 6, 10, 1, -1, -1, 1),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
  
)

# Indicamos que la columna y es la importante

datad$y <- as.factor(datad$y) 

# Creamos el SVM con los datos del D con un kernel lineal

svmd <- svm(y~., datad, kernel="linear")

#Vectores de soporte

vsd <- datad[svmd$index,1:2]

#Vector de pesos normal al hiperplano (W)
#CrosProduct entre los vectores soporte y el coe. de Lagrange

wd <- crossprod(as.matrix(vsd), svmd$coefs)

#Calcular ancho del canal

widthd = 2/(sqrt(sum((wd)^2)))

#Calcular vector B

bd <- -svmd$rho
#Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo

Withd=2 / (sum (sqrt ((wd)^2)))
paste(c("[",wd,"]' * x + [",bd,"] = 0"), collapse=" ")
paste(c("[",wd,"]' * x + [",bd,"] = 1"), collapse=" ")
paste(c("[",wd,"]' * x + [",bd,"] = -1"), collapse=" ")


## APARTADO E
#--------------------------------------------------------------------------
#Etiquetados positivamente/Etiquetados negativamente->Clasifica el punto [4.5] 


x1 = c(3,1)
x2 = c(3,-1)
x3 = c(6,1)
x4 = c(6,-1)
y1 = c(1,0)
y2 = c(0,1)
y3 = c(0,-1)
y4 = c(-1,0)

##DISTANCIAS----------------------------------------------------
#Distancia entre X1 y Y1
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2)
#Distancia entre X1 y Y2
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2)
#Distancia entre X1 y Y3
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2)
#Distancia entre X1 y Y4
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2)
#Distancia entre X2 y Y1
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2)
#Distancia entre X2 y Y2
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2)
#Distancia entre X2 y Y3
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2)
#Distancia entre X2 y Y4
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2)
#Distancia entre X3 y Y1
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2)
#Distancia entre X3 y Y2
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2)
#Distancia entre X3 y Y3
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2)
#Distancia entre X3 y Y4
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2)
#Distancia entre X4 y Y1
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2)
#Distancia entre X4 y Y2
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2)
#Distancia entre X4 y Y3
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2)
#Distancia entre X4 y Y4
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2)
##----------------------------------------------------------------
#A y B son los vectores soporte al tener menor distancia


#Calculamos los valores del kernel sabiendo que A y B son los vectores soporte
KAA=t (x1) %*% x1
KAB=t (x1) %*% y1
KBB=t (y1) %*% y1
# Creamos los datas para el ejercicio
datae <- data.frame(
 
   x1 = c(3,3,6,6,1,0,0,-1),
  x2 = c(1,-1,1,-1,0,1,-1,0),
  y = c(1,1,1,1,-1,-1,-1,-1)
  
)
# Indicamos que la columna y es la importante
datae$y <- as.factor(datae$y)
# Creamos el SVM con los datos del C con un kernel lineal
svme <- svm(y~., datae, kernel="linear")
#Vectores de soporte
vse <- datae[svme$index,1:2]
# Vector de pesos normal al hiperplano (W)
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange
we <- crossprod(as.matrix(vse), svme$coefs)
# Calcular ancho del canal
widthe = 2/(sqrt(sum((we)^2)))
# Calcular vector B
be <- -svme$rho
# Calcular la ecuacion del hiperplano y de los planos de soporte positivo
# y negativo
Withd=2 / (sum (sqrt ((we)^2)))
paste(c("[",we,"]' * x + [",be,"] = 0"), collapse=" ") 
paste(c("[",we,"]' * x + [",be,"] = 1"), collapse=" ")
paste(c("[",we,"]' * x + [",be,"] = -1"), collapse=" ") 


##APARTADO E
#---------------------------------------------------------
###Realiza los apartados anteriores con el dataset IRIS.

##cargamos los datos de iris:
data(iris)
dataf<- iris

#Creamos el SVM con un kernel radial:
svmf <- svm(Species~., data = iris, kernel="radial")

#Vectores Soporte:
vsf <- dataf[svmf$index,1:2]

#Vector de pesos normal al hiperplano (W)
#CrosProduct entre los vectores soporte y el cof. de Lagrange
wf <- crossprod(as.matrix(vsf), svmf$coefs)

#ancho del canal
widthF = 2/(sqrt(sum((wf)^2)))

#vector B
bf<- -svmF$rho

#ecuacion del hiperplano y de los planos de soporte positivo y negativo
Withd=2 / (sum (sqrt ((wf)^2)))

paste(c("[",wf,"]' * x + [",bf,"] = 0"), collapse=" ")
paste(c("[",wf,"]' * x + [",bf,"] = 1"), collapse=" ")
paste(c("[",wf,"]' * x + [",bf,"] = -1"), collapse=" ") 
