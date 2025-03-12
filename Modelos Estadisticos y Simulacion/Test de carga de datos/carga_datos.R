#mirar fechas, deteccion de patrones,mapas de grupos, 
#entrenar modelo con el isfraud para detectar fraude

#library(patchwork)
library(tidyr)
library(tidyverse)
library(ggplot2)
#cargamos la BD:
Bank_Transaction_Fraud_Detection <- read.csv("D:/github/university/Modelos Estadisticos y Simulacion/Test de carga de datos/Bank_Transaction_Fraud_Detection.csv")
#para verla:
View(Bank_Transaction_Fraud_Detection)

class(Bank_Transaction_Fraud_Detection) #data.frame

#cambiamos date a tipo date 
Bank_Transaction_Fraud_Detection$Transaction_Date <- as.Date(Bank_Transaction_Fraud_Detection$Transaction_Date, format= "%d-%m-%Y")

df<-Bank_Transaction_Fraud_Detection

#Estudio Variable Is_Fraud---------------------------------------------
#diagrama de barras
fraud<-df$Is_Fraud

fraud %>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=fraud, y=after_stat(prop)))
#funcion de distribucion muestral
fraud %>%
   data.frame() %>%
   ggplot() +
   stat_ecdf(aes(x=fraud))

#Estudio Variable Transaction Location----------------------------------
#diagrama de barras
location<- df$Transaction_Location

location %>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=location, y=after_stat(prop)))
#funcion de distribucion muestral
location %>%
   data.frame() %>%
   ggplot() +
   stat_ecdf(aes(x=location))
#Estudio Variable Transaction Device----------------------------------

#diagrama de barras
device<- df$Transaction_Device

device %>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=device, y=after_stat(prop)))
#funcion de distribucion muestral
device %>%
  data.frame() %>%
  ggplot() +
  stat_ecdf(aes(x=device))

#Estudio Variable Age--------------------------------------------------

#diagrama de barras
age<-df$Age

age%>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=age, y=after_stat(prop)))

#Estudio Variable Transaction Currency-----------------------------------

#diagrama de barras
currency<-df$Transaction_Currency

currency%>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=currency, y=after_stat(prop)))
#funcion de distribucion muestral
currency %>%
  data.frame() %>%
  ggplot() +
  stat_ecdf(aes(currency))

#Estudio Variable Account Type--------------------------------------------

tipo<-df$Account_Type

tipo%>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=tipo, y=after_stat(prop)))
#funcion de distribucion muestral
tipo %>%
  data.frame() %>%
  ggplot() +
  stat_ecdf(aes(x=tipo))

#Estudio Variable Gender---------------------------------------------------

gender<-df$Gender

gender%>%
  data.frame() %>%
  ggplot() +
  geom_bar(aes(x=gender, y=after_stat(prop)))

#funcion de distribucion muestral
gender %>%
  data.frame() %>%
  ggplot() +
  stat_ecdf(aes(x=gender))
