#EJEMPLO 1
#generamos una mueestra:
x <- rnorm(20,mean=5,sd=1)
#r->numeros aleatorios : 20 numeros aleatorios

##definimos la funcion kernel
gaussian_kernel<- function(x,xi,h){
#dominio de la funcion: x
#media de la distribucion gaussiana(el medio): xi
  dnorm(x,mean=xi,sd=h)
  #funcion equivalente== (1/(h*sqrt(2*pi)))*exp(-(x-xi)^2/(2*h^2))
}

#kda bandwidth
h<- 10 #1.06*sd(x)*length(x)^(-1/5)

gaussian_kernel(x_seq ,x[1],h)
for(i in x){
  gaussian_kernel(x_seq,x[i], h)
}
plot(x_seq,gaussian_kernel(x_seq,x[1],h),type = "l")

lapply(x, function(xi) gaussian_kernel(x_seq,xi,h))
#generamos secuencia de x
x_seq <- seq(min(x)-1, max(x)+1, length.out = 200)
#
kde_values<-density(x,bw=h)
#
individual_kernels <-data.frame(
  x = rep(x_seq,times=length(x)),
  y=unlist(lapply(x,function(xi)gaussian_kernel(x_seq,xi,h)))(length(x)),
  group =
)


#EJEMPLO 2

x<-rnorm(20,mean=5,sd=1)

x_contaminada <- x
x_contaminada[1] <- 1000

mean(x)
median(x)

mean(x_contaminada)
median(x_contaminada)








