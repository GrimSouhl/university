
######EL PRIMER APARTADO SE ENCUENTRA EN EL FOLIO.
##NOS SALIO EL ATRIBUTO: GILL-SIZE



###APARTADO 2:
library(kernlab)

##CREAMOS EL DATAFRAME:
cap_shape <- c("CONVEX", "CONVEX", "BELL", "CONVEX", "CONVEX", "BELL", "CONVEX")
cap_color <- c("BROWN", "YELLOW", "WHITE", "WHITE", "YELLOW", "WHITE", "WHITE")
gill_size <- c("NARROW", "BROAD", "BROAD", "NARROW", "BROAD", "BROAD", "NARROW")
gill_color <- c("BLACK", "BLACK", "BROWN", "BROWN", "BROWN", "BROWN", "PINK")
classification <- c("POISONOUS", "EDIBLE", "EDIBLE", "POISONOUS", "EDIBLE", "EDIBLE", "POISONOUS")

data<-data.frame(CAP_SHAPE = cap_shape, CAP_COLOR = cap_color, GILL_SIZE = gill_size, GILL_COLOR = gill_color, CLASSIFICATION = classification)

##LA DEFINICION DE VARIABLES NO ME DA TIEMPO

#ENTRENAMOS EL MODELO:
model <- ksvm(CLASSIFICATION ~ ., data = data, type = "C-svc", kernel = "rbfdot", kpar = list(sigma = 0.2), C = 5)

##OBTENEMOS LOS PARAMETROS:
ancho_del_canal <- model@width
b <- model@b
vector_de_pesos <- model@coeficients


##LA ECUACION DEL HIPERPLANO:
##NO ME DA TIEMPO

##REALIZAMOS LA PREDICCION:
nueva_seta <- data.frame(CAP_SHAPE = "BELL", CAP_COLOR = "WHITE", GILL_SIZE = "BROAD", GILL_COLOR = "BLACK")
prediccion <- predict(model, nueva_seta)