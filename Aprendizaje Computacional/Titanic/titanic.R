library(e1071)
library(nnet)
library(rpart)
library(pROC)
library(kernlab)
library(dplyr)
library(knitr)
library(ROCR)
library(caret)
library(DataExplorer)

data_titanic <- read.csv("D:/AP/PRACTICATITANIC/canon/train.csv", stringsAsFactors=TRUE)
testeo <- read.csv("D:/AP/PRACTICATITANIC/canon/test.csv", stringsAsFactors=TRUE)

#-------------------------( 1 )-----------------------------------------
# En primer lugar, realizaremos un examen del dataset y estudiaremos 
# los atributos y si aparecen datos faltantes. Como final de la fase de 
#preprocesamiento obtendremos un dataset en el que se hayan eliminado
# los atributos innecesarios y se haya solucionado los atributos faltantes.

# Eliminar datos faltantes (Na)
data_titanic<-na.omit(data_titanic)

# Eliminar columnas no necesarias
##train.csv
data_titanic <- data_titanic[,-1] #Id pasajero
data_titanic <- data_titanic[,-3] #Nombre
data_titanic <- data_titanic[,-7] #Ticket
data_titanic <- data_titanic[,-8] #Cabin
data_titanic <- data_titanic[,-8] #Embarked

##test.csv
testeo <- testeo[,-1] #Id pasajero
testeo <- testeo[,-2] #Nombre
testeo <- testeo[,-6] #Ticket
testeo <- testeo[,-7] #Cabin
testeo <- testeo[,-7] #Embarked
#----------------------------------------------------------------------


#-------------------------( 2 )----------------------------------------
# En segundo lugar, entrenaremos a cada uno de los clasificadores 
# (Rpart, nnet, e1071) usando validación cruzada. Obtendremos el accuracy
# y el área bajo la curva para cada clasificador.

#Primero preparamos los datos que vamos a usar para entrenar y ver qué modelo es el mejor.

set.seed(200)
d_size<-dim(data_titanic)[1]
dtest_size <- ceiling(0.2*d_size)
samples<-sample(d_size, d_size, replace=FALSE)
indexes<-samples[1:dtest_size]
dtrain<-data_titanic[-indexes,]
dtest<-data_titanic[indexes,]
#Ponemos como factor la clase:
dtrain[,1] <- as.factor(dtrain[,1]) 
dtest[,1] <- as.factor(dtest[,1])

#---------------------------------------------------------------------------------------------
#Empezamos con el SVM, del cual tras probar con los diferentes tipos sacamos los dos mejores
#el lineal y el Gaussiano
#---------------------------------------------------------------------------------------------

##### SVM Lineal ############
tune_l = tune.svm(Survived~., data = dtrain, kernel="linear", cost = c(0.001, 0.01, 0.1, 1, 5, 10, 50))
model_svm_l <- svm(Survived~., data = dtrain, type = "C-classification", kernel = "linear", cost = tune_l$best.parameters$cost, scale = FALSE, probability = TRUE)
matrizconfusionSVM_l <- table(predict(model_svm_l, dtest), dtest$Survived , dnn = c("Prediction", "Actual"))
accuracySVM_l <- sum(diag(matrizconfusionSVM_l)) / sum(matrizconfusionSVM_l)
accuracySVM_l #0.7622378

####### PINTAMOS LA CURVA ROC DEL SVM LINEAL #############
##Obtenemos las probabilidades predichas del modelo:
distancias <- predict(model_svm_l, dtest, decision.values = TRUE)
#Tomamos las puntuaciones de decisión de la clase positiva
puntuaciones_decision <- distancias 
#Creamos un objeto ROC
roc_objSVMGaussiano <- roc(dtest$Survived, as.numeric(puntuaciones_decision))
auc_valueSVM <- auc(roc_objSVMGaussiano) ##area bajo la curva
#Ploteamos la curva ROC
plot(roc_objSVMGaussiano, main = "Curva ROC", col = "blue", lwd = 2)
#Añadimos etiquetas y leyenda
lines(c(0, 1), c(0, 1), col = "grey", lty = 2, lwd = 2)
legend("bottomright", legend = sprintf("AUC = %.2f", auc(roc_objSVMGaussiano)),
       col = "blue", lwd = 1.5)


##### SVM Gaussiano ############
tune_r = tune.svm(Survived~., data = dtrain, kernel="radial",cost = c(0.1,1,10,100,1000), gamma = c(0.5,1,2,3,4))
model_svm_r <- svm(Survived~., data = dtrain, type = "C-classification", kernel = "radial", cost = tune_r$best.parameters$cost, gamma = tune_r$best.parameters$gamma, probability = TRUE)
matrizconfusionSVM_r <- table(predict(model_svm_r, dtest), dtest$Survived , dnn = c("Prediction", "Actual"))
accuracySVM_r <- sum(diag(matrizconfusionSVM_r)) / sum(matrizconfusionSVM_r)
accuracySVM_r #0.7762238<----

####### PINTAMOS LA CURVA ROC DEL SVM Gaussiano #############
##Obtenemos las probabilidades predichas del modelo:
distancias <- predict(model_svm_r, dtest, decision.values = TRUE)
#Tomar las puntuaciones de decisión de la clase positiva
puntuaciones_decision <- distancias 
#Creamos un objeto ROC
roc_objSVMGaussiano <- roc(dtest$Survived, as.numeric(puntuaciones_decision))
auc_valueSVM <- auc(roc_objSVMGaussiano) ##area bajo la curva
#Ploteamos la curva ROC
plot(roc_objSVMGaussiano, main = "Curva ROC", col = "blue", lwd = 2)
#Añadimos etiquetas y leyenda
lines(c(0, 1), c(0, 1), col = "grey", lty = 2, lwd = 2)
legend("bottomright", legend = sprintf("AUC = %.2f", auc(roc_objSVMGaussiano)),
       col = "blue", lwd = 1.5)

##El Gaussiano nos da mejor accuracy


#---------------------------------------------------------------------------------------------
# Seguimos con el PERCEPTRON (NNET):
#---------------------------------------------------------------------------------------------
tune_n <- tune.nnet(Survived~., data = dtrain, size = 100, cost = c(0.001, 0.01, 0.1, 1, 5, 10, 50), maxit=200, MaxNWts=100000, decay=1e-4)
nnet_n <- nnet(Survived ~., data = dtrain, size = 100, cost = tune_l$best.parameters$cost,  maxit=200, MaxNWts=100000, decay=1e-4)
prediction_n <- as.factor(predict(nnet_n, dtest, type = "class"))
matrizConfusion_n <- confusionMatrix(prediction_n, dtest$Survived)
matrizConfusion_n$overall[1] #0.7342657 

####### PINTAMOS LA CURVA ROC DEL PERCEPTRON (NNET) #############
roc_nnet_n <- roc(dtest$Survived, as.numeric(prediction_n))
plot(roc_nnet_n, main = "Curva ROC - Perceptrón", col = "blue", lwd = 2)
lines(c(0, 1), c(0, 1), col = "grey", lty = 2, lwd = 2)
legend("bottomright", legend = sprintf("AUC = %.2f", auc(roc_nnet_n)),
       col = "blue", lwd = 1.5)



#---------------------------------------------------------------------------------------------
#     RPART:
#---------------------------------------------------------------------------------------------
rpart_rp <- rpart(Survived ~. , data=dtrain, control = rpart.control(minbucket  = 5))
prediction_rp <- predict(rpart_rp, newdata = dtest, type = "class")
matrizConfusion_rp <- confusionMatrix(prediction_rp, dtest$Survived)
matrizConfusion_rp$overall[1] #0.7412587




##ROC DE RPART:
roc_curve <- roc(dtest$Survived, as.numeric(prediction_rp))

plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
auc_value <- auc(roc_curve)
legend("bottomright", legend = paste("AUC =", round(auc_value, 3)), col = "blue", lty = 1, cex = 0.8)
abline(a = 0, b = 1, lty = 2, col = "grey")


#-------------------------( 3 )----------------------------------------

#En tercer lugar, vamos a entrenar a cada uno de los clasificadores, usando 
# validación cruzada y modificando sus parámetros como CP , size o el tipo de
# kernel, con el objetivo de encontrar el clasificador mejor de su clase.

#(!!!)La funcion 'tune' ejecutada antes de cada clasificador en el ejercicio 2 
#la usamos para elegir el mejor modelo de entre todos los que se han calculado directamente.

#-------------------------( 4 )----------------------------------------
#Una vez tenemos todos los modelos escogemos el que mejor accuracy nos dió, que fue el
#SVM Gaussiano, con este realizaremos las predicciones sobre el conjunto test
#como se nos pide en el ejercicio

predicciones <- predict(model_svm_r, testeo)
predicciones


