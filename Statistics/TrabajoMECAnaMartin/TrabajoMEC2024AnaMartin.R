##Primero cargamos la Librería que vamos a usar:
library(tidyverse)

##Dejare este apartado para funciones compartidas:
##FUNCIONES:
#----------------------------------------------

##Funcion de desviacion típica:
desviacion_tipica <- function(x) {
  return(sd(x) * sqrt((length(x)-1) / length(x)))
}
#...
##El resto están en sus apartados para mejor visualización
#...
#(8) entrenar_y_evaluar_modelo(variable, conjunto_entrenamiento, conjunto_pruebas)
#...
#----------------------------------------------


##EJERCICIOS:

##(1)Carga en memoria el fichero CSV como tibble, asegurándote de que las variables
##cualitativas sean leídas como factores
#----
#Observamos los datos y vemos que las variables cualitativas son:
# sexo   y    dietaEsp
csv <- read_csv("D:\\1Estadistica\\17206.csv", 
                col_types = cols(.default = col_double(),
                                 sexo = col_factor(), 
                                 dietaEsp = col_factor()))
csv

##(2)Construye una nueva columna llamada IMC 
##que sea igual al peso dividido por la altura
##al cuadrado. La variable explicada será IMC, 
##las variables explicatorias serán el resto
##de 12 variables exceptuando peso y altura.

#Vamos entonces a añadir a csv la columna IMC con la especificación dada:

csv <- add_column(csv, IMC = csv$peso/(csv$altura^2))
csv

##(3)Elimina completamente las filas que tengan algún valor NA en una de sus columnas.

csv<- na.omit(csv)
csv

##(4)Calcula las medias y desviaciones típicas (no cuasidesviación) de todas las variables numéricas.

#sapply()->aplica una función a cada elemento de una lista o vector, y devuelve un vector o matriz.
#function(x)->define una función anónima que se aplicará a cada columna 
#is.numeric()->comprueba si la columna x es de tipo numérico 
medias<- sapply(csv, function(x) if(is.numeric(x)) mean(x) else NA)
medias

#Usamos la funcion que creamos en FUNCIONES(arriba del todo)
desviaciones_tipicas <- sapply(csv, function(x) if(is.numeric(x)) desviacion_tipica(x) else NA)
desviaciones_tipicas


##(5)Calcula los coeficientes de regresión y el coeficiente de determinación para
#las 12 regresiones lineales unidimensionales 
##de la variable IMC a partir de cada una de las 12 variables separadamente
# Crear un vector para almacenar los coeficientes de regresión y R-cuadrado

# Creamos coeficientes para almacenar nuestros coeficientes:
coeficientes <- data.frame(Variable = character(),
                           Coeficiente_Regresion = numeric(),
                           Coeficiente_Determinacion = numeric(),
                           stringsAsFactors = FALSE)

# Iteramos sobre cada variable independiente (nos pide usar las 12)
for (variable in names(csv)[!names(csv) %in% "IMC"]) {
  
  # Ajustamos el modelo de regresión lineal
  modelo <- lm(IMC ~ csv[[variable]], data = csv)
  
  # Obtenemos los coeficientes de regresión y R-cuadrado(determinacion)
  coef_regresion <- coef(summary(modelo))[2, 1]
  r_cuadrado <- summary(modelo)$r.squared
  
  # Guardar los resultados en el vector que creamos
  coeficientes[nrow(coeficientes) + 1, ] <- c(variable, coef_regresion, r_cuadrado)
}

# Mostramos los resultados
coeficientes



#(6)Representa los gráficos de dispersión en el caso de variables numéricas 
#y los boxplots en el caso de variables cualitativas. 
#En el caso de las variables numéricas (y sólo en ese caso) 
#el gráfico debe tener sobreimpresa la recta de regresión simple correspondiente.

# Creamos un directorio para almacenar los gráficos si no existe
dir.create("D:/1Estadistica/graficos", showWarnings = FALSE)

#Vamos a cargar lalibrería ggplot2 la cual tiene muchas aplicaciones para generar graficos:
library(ggplot2)

#gráficos de dispersión con recta de regresión para las variables numéricas:
for (variable in names(csv)[!names(csv) %in% c("IMC", "sexo", "dietaEsp")]) {
  modelo <- lm(IMC ~ ., data = csv[, c(variable, "IMC")])
  grafico <- ggplot(data = csv, aes_string(x = variable, y = "IMC")) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(x = variable, y = "IMC") +
    ggtitle(paste("Gráfico de dispersión para", variable))
  
  # Guardamos el gráfico en el directorio
  ggsave(filename = paste("D:/1Estadistica/graficos/", variable, "_vs_IMC.png", sep = ""), plot = grafico)
}

# Boxplots para las Variables cualitativas
for (variable in c("sexo", "dietaEsp")) {
  grafico <- ggplot(data = csv, aes_string(x = variable, y = "IMC")) +
    geom_boxplot() +
    labs(x = variable, y = "IMC") +
    ggtitle(paste("Boxplot para", variable))
  
  # Guardamos el gráfico en el directorio
  ggsave(filename = paste("D:/1Estadistica/graficos/", variable, "_vs_IMC.png", sep = ""), plot = grafico)
}


##(7)Separa el conjunto original de datos en tres conjuntos de entrenamiento,
##test y validación en las proporciones 60%, 20% y 20%.

#Existe la librería caret que nos permite particionar los conjuntos de una forma más sencilla
#Exportamos la librería:
library(caret)

#Establecemos una semilla:
set.seed(123)

#Creamos las particiones para entrenamiento (60%), prueba (20%) y validación (20%)
indices_entrenamiento <- createDataPartition(csv$IMC, p = 0.6, list = FALSE) #60%
indices_prueba_validacion <- createDataPartition(csv[-indices_entrenamiento, ]$IMC, p = 0.5, list = FALSE)#lo restante se divide 50/50

#Sacamos el Conjunto de entrenamiento
conjunto_entrenamiento <- csv[indices_entrenamiento, ]
conjunto_entrenamiento

#Sacamos el conjunto de pruebas
conjunto_prueba <- csv[-indices_entrenamiento, ][indices_prueba_validacion, ]
conjunto_prueba

#Sacamos el conjunto de validacion
conjunto_validacion <- csv[-c(indices_entrenamiento, indices_prueba_validacion), ]
conjunto_validacion


##(8)Selecciona cuál de las 12 variables sería la que mejor explica la variable IMC de manera individual,
##entrenando con el conjunto de entrenamiento y testeando con el conjunto de test.

#Vamos a automatizar el proceso
#Para ello, creamos una función para entrenar y evaluar un modelo de regresión lineal para una variable dada:

entrenar_y_evaluar_modelo <- function(variable, conjunto_entrenamiento, conjunto_prueba) {
  #Ajustamos el modelo de regresión lineal:
  modelo <- lm(IMC ~ ., data = conjunto_entrenamiento[, c(variable, "IMC")])
  
  #Predecimos los valores de IMC para el conjunto de prueba:
  predicciones <- predict(modelo, newdata = conjunto_prueba[, variable])
  #Calculamos el coeficiente de determinación (R-cuadrado) para evaluar el desempeño del modelo
  r_cuadrado <- summary(modelo)$r.squared
  #Devolvemos el R-cuadrado del modelo
  return(r_cuadrado)
}

#Creamos un vector para almacenar los R-cuadrados de los diferentes modelos
r_cuadrados <- numeric(length = 12)

#Iteramos sobre las variables independientes y entrenamos y evaluamos un modelo para cada una
for (variable in names(conjunto_entrenamiento)[!names(conjunto_entrenamiento) %in% c("IMC")]) {
  r_cuadrados[variable] <- entrenar_y_evaluar_modelo(variable, conjunto_entrenamiento, conjunto_prueba)
}

#Seleccionamos la variable con el mayor R-cuadrado
mejor_variable <- names(r_cuadrados)[which.max(r_cuadrados)]
mejor_variable



##(9)Selecciona un modelo óptimo lineal de regresión, entrenando en el conjunto de entrenamiento,
##testeando en el conjunto de test el coeficiente de determinación ajustado y utilizando una técnica
##progresiva de ir añadiendo la mejor variable.


#Función para entrenar y evaluar un modelo con una variable dada de forma ajustada:
entrenar_y_evaluar_modelo_ajustado <- function(variables, conjunto_entrenamiento, conjunto_prueba) {
  formula <- as.formula(paste("IMC ~", paste(variables, collapse = "+")))
  modelo <- lm(formula, data = conjunto_entrenamiento)
  r_cuadrado_ajustado <- summary(modelo)$adj.r.squared
  return(r_cuadrado_ajustado)
}

#Conjunto de variables disponibles para usar
variables_disponibles <- setdiff(names(conjunto_entrenamiento), "IMC")
variables_disponibles

#Inicializamos la lista de variables seleccionadas y el coeficiente de determinación ajustado máximo
variables_seleccionadas <- character(0)
r_cuadrado_maximo <- 0

#Iteramos para añadir la mejor variable en cada paso
while (length(variables_disponibles) > 0) {
  r_cuadrados <- sapply(variables_disponibles, function(variable) {
    entrenar_y_evaluar_modelo_ajustado(c(variables_seleccionadas, variable), conjunto_entrenamiento, conjunto_prueba)
  })
  
  mejor_variable <- names(r_cuadrados)[which.max(r_cuadrados)]
  mejor_r_cuadrado <- max(r_cuadrados)
  
  if (mejor_r_cuadrado > r_cuadrado_maximo) {
    variables_seleccionadas <- c(variables_seleccionadas, mejor_variable)
    r_cuadrado_maximo <- mejor_r_cuadrado
    variables_disponibles <- setdiff(variables_disponibles, mejor_variable)
  } else {
    break
  }
}

#Entrenamos el modelo final utilizando todas las variables seleccionadas
formula_final <- as.formula(paste("IMC ~", paste(variables_seleccionadas, collapse = "+")))
modelo_final <- lm(formula_final, data = conjunto_entrenamiento)

#Evaluamos el modelo final en el conjunto de prueba
r_cuadrado_ajustado_final <- summary(modelo_final)$adj.r.squared

#Mostramos las variables seleccionadas y el coeficiente de determinación ajustado del modelo final
variables_seleccionadas
r_cuadrado_ajustado_final



##(10)Evalúa el resultado en el conjunto de validación.

#Vamos a preparar los datos de validación, primero predecimos los valores de IMC en el conjunto de validación:
predicciones_validacion <- predict(modelo_final, newdata = conjunto_validacion)
predicciones_validacion
#Luego calculamos los r_cuadrado_ajustado
r_cuadrado_ajustado_validacion <- 1 - (sum((conjunto_validacion$IMC - predicciones_validacion)^2) / sum((conjunto_validacion$IMC - mean(conjunto_validacion$IMC))^2))

r_cuadrado_ajustado_validacion


##(11)Lee el dataframe de evaluación que te habrá llegado (eval.csv) 
##y utiliza el modelo creado para añadirle una nueva columna con el valor de la variable IMC y,
##a continuación, otra columna con el valor de la variable Peso. Salva el resultado como evalX.csv para enviarlo
##como parte de la solución al trabajo

# Leer el dataframe de evaluación
evaluacion <- read_csv("D:\\1Estadistica\\eval.csv",col_types = cols(.default = col_double(),
                                                                     sexo = col_factor(), 
                                                                     dietaEsp = col_factor()))
evaluacion

#Ajustamos el modelo y la fórmula ya que evaluacion no contiene la columna peso
formula_final_sin_peso <- update(formula_final, . ~ . - peso)
modelo_final_sin_peso <- lm(formula_final_sin_peso, data = conjunto_entrenamiento)
#Predecimos el IMC en el conjunto de evaluación utilizando el modelo final sin la variable de peso
evaluacion$IMC_predicho <- predict(modelo_final_sin_peso, newdata = evaluacion)
#Calculamos el peso basado en IMC predichoD
evaluacion$peso_predicho <- evaluacion$IMC_predicho * (evaluacion$altura^2)

evaluacion

#Guardamos el resultado como evalX.csv
write_csv(evaluacion, "D:\\1Estadistica\\eval.csv")
