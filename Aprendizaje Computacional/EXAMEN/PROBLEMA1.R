###Explica de forma general cómo resolver el problema. Enumera los atributos del
##dataframe y su significado así como el atributo de clasificación. Pon ejemplos,
##indicando la configuración del tablero y su clasificación

##-------solucion:------
##ATRIBUTOS DEL PROBLEMA:

##cada celda del tablero(p1,p2,p3,.p9) 
#sería un atributo que puede contener 'x', 'o', o estar 'vacía'

##El atributo de clasificación sería la acción que puede cometer el jugador

##EJEMPLOS:
##| p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | p9 | clasificacion |
##|----|----|----|----|----|----|----|----|----|---------------|
##| X  | o  |    | X  | O  |    |    |    |    |       7       |
##| X  |    | o  | X  | O  |    |    |    |    |       6       |
##| X  |    |    | O  | O  | X  |    | X  |    |       5       |
##|    |    |    | O  | X  |    |    |    | X  |       1       |
##----------------------------------------------------------------------

#####APARTADO 2:

#creamos los datos del dataframe:.
data <- list(
  c1 = c('X','X','X', 'O', '', 'O','X','','X'),
  c2 = c('O', '', '', 'X', '', 'X', 'O', '', ''),
  c3 = c('', 'O', '', '', 'X', '', '', 'X', ''),
  c4 = c('X', 'X', 'O', '', '', '', 'O', '', 'O'),
  c5 = c('O', 'O', 'O', 'O', 'O', '', 'X', 'O', 'X'),
  c6 = c('', '', '', '', '', '', '', '', ''),
  c7 = c('', '', 'X', '', '', 'O', '', 'X', 'O'),
  c8 = c('', '', '', '', '', 'X', '', '', 'O'),
  c9 = c('', '', 'X', 'X', 'X', '', '', '', 'X'),
  clasificacion = c(7, 6, 5, 2, 1, 4, 9, 8, 6)
)

#creamos el dataframe:
df <- as.data.frame(data)

#Para ver el dataframe:
print(df)

####APARTADO 3:

##cargamos los diferentes modeloss:
library(rpart)
library(nnet)
library(e1071)
library(kernlab)
##sacamos conjunto de entrenamiento y el conjunto de prueba:

library(caret)


set.seed(123)  # Para reproducibilidad
ie <- createDataPartition(df$clasificacion, p = 0.8, list = FALSE)

# Conjunto de entrenamiento
train_data <- df[ie, ]

# Conjunto de prueba
test_data <- df[-ie, ]

# Árbol de decisión CART (rpart)
t_cart <- proc.time()
modelo_cart <- rpart(clasificacion ~ ., data = train_data, method = "class")
tiempo_cart <- proc.time() - t_cart

# Perceptrón (nnet)
t_perceptron <- proc.time()
modelo_perceptron <- nnet(clasificacion ~ ., data = train_data, size = 5, linout = TRUE)
tiempo_perceptron <- proc.time() - t_perceptron

# Máquinas de soporte vectorial (e1071)
t_svm <- proc.time()
modelo_svm <- svm(clasificacion ~ ., data = train_data, kernel = "radial")
tiempo_svm <- proc.time() - t_svm

# Máquinas de soporte vectorial (kernlab)
t_kernlab <- proc.time()
modelo_kernlab <- ksvm(clasificacion ~ ., data = train_data, kernel = "rbfdot")
tiempo_kernlab <- proc.time() - t_kernlab


##vemos los tiempos:
tiempo_cart
tiempo_perceptron
tiempo_svm
tiempo_kernlab


##nos salio mejor en nuestro sistema el perceptron (0.48 SEGUNDOS)
##CART: 0.80
##SVM: 8.97
#KERNLAB: 1.31



##4-REALIZAR EL ENTRENAMIENTO USANDO PERCEPTRON:

##PONGO DE NUEVO LOS DATOS:

#creamos los datos del dataframe:.
data <- list(
  c1 = c('X','X','X', 'O', '', 'O','X','','X'),
  c2 = c('O', '', '', 'X', '', 'X', 'O', '', ''),
  c3 = c('', 'O', '', '', 'X', '', '', 'X', ''),
  c4 = c('X', 'X', 'O', '', '', '', 'O', '', 'O'),
  c5 = c('O', 'O', 'O', 'O', 'O', '', 'X', 'O', 'X'),
  c6 = c('', '', '', '', '', '', '', '', ''),
  c7 = c('', '', 'X', '', '', 'O', '', 'X', 'O'),
  c8 = c('', '', '', '', '', 'X', '', '', 'O'),
  c9 = c('', '', 'X', 'X', 'X', '', '', '', 'X'),
  clasificacion = c(7, 6, 5, 2, 1, 4, 9, 8, 6)
)



set.seed(123)  # Para reproducibilidad
ie <- createDataPartition(df$clasificacion, p = 0.8, list = FALSE)

# Conjunto de entrenamiento
train_data <- df[ie, ]

# Conjunto de prueba
test_data <- df[-ie, ]

#ENTRENAMOS EL MODELO DEL PERCEPTRON:
modelo_perceptron <- nnet(clasificacion ~ ., data = train_data, size = 5, linout = TRUE)

#REALIZAMOS LAS PREDICCIONES EN EL CONJUNTO DE PRUEBA
predicciones <- predict(modelo_perceptron, newdata = test_data, type = "class")

#MIRAMOS EL RENDIMIENTO DEL MODELO
aciertos <- sum(predicciones == test_data$clasificacion) / length(test_data$clasificacion)

#VEMOS ELNUMERO DE ACIERTOS DEL MODELO
print(modelo_perceptron)
cat("aciertos en el conjunto de prueba:", aciertos, "\n")
save(modelo_perceptron, file = "modelo_perceptron.rda")



##APARTADO 5-CARGAR CON LOAD Y DEVOLVER DONDE COLOCAR LA FICHA

#CARGAMOS EL MODELO ENTRENADO CON ANTERIORIDAD:
load("modelo_perceptron.rda")

#CREAMOS UNA FUNCION QUE NOS PREDIGA MOVIMIENTOS SEGUN EL ESTADO EN EL QUE ESTA EL TABLERO
predecir <- function(tablero) {
  #creamos dataframe con el estado que cargamos
  new_state <- as.data.frame(matrix(unlist(strsplit(tablero, "")), nrow = 1))
  
  #realizamos la prediccion
  prediccion <- predict(modelo_perceptron, newdata = new_state, type = "class")
  
  #devolvemos la prediccion
  return(prediccion)
}

###DEVOLVEMOS LA SOLUCION:
solucion5 <- predecir(modelo_perceptron)




###APARTADO 6(no me da tiempo a realizarlo):




