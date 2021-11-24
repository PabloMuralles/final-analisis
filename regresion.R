###########################################################################################
#conexion
install.packages("ggiraphExtra")
install.packages("ggiraph")
install.packages("ggplot2")
install.packages("odbc")
library(odbc)
library(dplyr)
library(plyr)
library(ggplot2)
library(ggiraph)
library(ggiraphExtra)

con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "DESKTOP-34T1EIQ",
                 Database = "RepuestosWeb",
                 timeout = 50)
#1--##########################################################################################
#regresion total orden con geografia

dfTotalOrdenGeografia<-dbGetQuery(con=con, "select O.Total_Orden, c.Nombre as NombreCiudad, R.Nombre as NombreRegion, P.Nombre as NombrePais
                                            from Orden O inner join Ciudad C on O.ID_Ciudad=C.ID_Ciudad
                                    				inner join Region R on C.ID_Region=r.ID_Region
                                    				inner join Pais P on R.ID_Pais = p.ID_Pais")
#limpiar data
dfTotalOrdenGeografia <- na.omit(dfTotalOrdenGeografia)

#transformar data
dfTotalOrdenGeografia<- transform(dfTotalOrdenGeografia,NombreCiudad=as.numeric(as.factor(NombreCiudad)))
dfTotalOrdenGeografia<- transform(dfTotalOrdenGeografia,NombreRegion=as.numeric(as.factor(NombreRegion)))
dfTotalOrdenGeografia<- transform(dfTotalOrdenGeografia,NombrePais=as.numeric(as.factor(NombrePais)))

#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfTotalOrdenGeografia), 0.8*nrow(dfTotalOrdenGeografia))  
trainingDataTotalOrdenGeografia <- dfTotalOrdenGeografia[trainingRowIndex, ]  
testDataTotalOrdenGeografia  <- dfTotalOrdenGeografia[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmTotalOrdenGeografia <- lm(Total_Orden ~ NombreCiudad+NombreRegion+NombrePais, data=trainingDataTotalOrdenGeografia)  
summary (lmTotalOrdenGeografia) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfTotalOrdenGeografia$Total_Orden, dfTotalOrdenGeografia$NombreCiudad)
cor(dfTotalOrdenGeografia$Total_Orden, dfTotalOrdenGeografia$NombreRegion)
cor(dfTotalOrdenGeografia$Total_Orden, dfTotalOrdenGeografia$NombrePais)
cor(dfTotalOrdenGeografia$Total_Orden, dfTotalOrdenGeografia$NombrePais+dfTotalOrdenGeografia$NombreRegion+dfTotalOrdenGeografia$NombreCiudad)

##plot
dfPlotTotalOrdenGeografia<-head(dfTotalOrdenGeografia,250)
#dfPlotTotalOrdenGeografia<-dfTotalOrdenGeografia
scatter.smooth(x=dfPlotTotalOrdenGeografia$Total_Orden, y=dfPlotTotalOrdenGeografia$NombreCiudad+dfPlotTotalOrdenGeografia$NombreRegion+dfPlotTotalOrdenGeografia$NombrePais, main="Cantidad~Marca+Modelo+Anio")
boxplot(dfPlotTotalOrdenGeografia$NombreCiudad, main="Nombre Ciudad", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenGeografia$NombreRegion)$out))
boxplot(dfPlotTotalOrdenGeografia$NombreRegion, main="Nombre Region", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenGeografia$NombreCiudad)$out))
boxplot(dfPlotTotalOrdenGeografia$NombrePais, main="Nombre Pais", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenGeografia$NombrePais)$out))
#2--#####################################################################################################################
dfTotalOrdenPartes<-dbGetQuery(con=con, "select O.Total_Orden, P.Nombre as NombreParte, C.Nombre as NombreCategoria, L.Nombre as NombreLinea
                                              from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden
                                              				inner join Partes P on De.ID_Parte = P.ID_Parte
                                              				inner join Categoria C on P.ID_Categoria = C.ID_Categoria
                                              				inner join Linea L on C.ID_Linea = L.ID_Linea")
#limpiar data
dfTotalOrdenPartes <- na.omit(dfTotalOrdenPartes)

#transformar data
dfTotalOrdenPartes<- transform(dfTotalOrdenPartes,NombreParte=as.numeric(as.factor(NombreParte)))
dfTotalOrdenPartes<- transform(dfTotalOrdenPartes,NombreCategoria=as.numeric(as.factor(NombreCategoria)))
dfTotalOrdenPartes<- transform(dfTotalOrdenPartes,NombreLinea=as.numeric(as.factor(NombreLinea)))

#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfTotalOrdenPartes), 0.8*nrow(dfTotalOrdenPartes))  
trainingDataTotalOrdenPartes <- dfTotalOrdenPartes[trainingRowIndex, ]  
testDataTotalOrdenPartes  <- dfTotalOrdenPartes[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmTotalOrdenPartes <- lm(Total_Orden ~ NombreParte+NombreCategoria+NombreLinea, data=trainingTotalOrdenPartes)  
summary (lmTotalOrdenPartes) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfTotalOrdenPartes$Total_Orden, dfTotalOrdenPartes$NombreParte)
cor(dfTotalOrdenPartes$Total_Orden, dfTotalOrdenPartes$NombreCategoria)
cor(dfTotalOrdenPartes$Total_Orden, dfTotalOrdenPartes$NombreLinea)
cor(dfTotalOrdenPartes$Total_Orden, dfTotalOrdenPartes$NombreParte+dfTotalOrdenPartes$NombreCategoria+dfTotalOrdenPartes$NombreLinea)

##plot
dfPlotTotalOrdenPartes<-head(dfTotalOrdenPartes,250)
scatter.smooth(x=dfPlotTotalOrdenPartes$Total_Orden, y=dfPlotTotalOrdenPartes$NombreParte+dfPlotTotalOrdenPartes$NombreCategoria+dfPlotTotalOrdenPartes$NombreLinea, main="Cantidad~Parte+Categoria+Linea")
boxplot(dfPlotTotalOrdenPartes$NombreParte, main="Nombre Parte", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenPartes$NombreParte)$out))
boxplot(dfPlotTotalOrdenPartes$NombreCategoria, main="Nombre Categoria", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenPartes$NombreCategoria)$out))
boxplot(dfPlotTotalOrdenPartes$NombreLinea, main="Nombre Linea", sub=paste("Outlier rows: ", boxplot.stats(dfPlotTotalOrdenPartes$NombreLinea)$out))
#3--#####################################################################################################################
dfTotalOrdenVehiculos<-dbGetQuery(con=con, "select O.Total_Orden, V.Anio, V.Marca, V.Modelo
                                          from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden 
                                          				inner join Vehiculo V on De.VehiculoID=V.VehiculoID")
#limpiar data
dfTotalOrdenVehiculos <- na.omit(dfTotalOrdenVehiculos)

#transformar data
dfTotalOrdenVehiculos<- transform(dfTotalOrdenVehiculos,Marca=as.numeric(as.factor(Marca)))
dfTotalOrdenVehiculos<- transform(dfTotalOrdenVehiculos,Modelo=as.numeric(as.factor(Modelo)))

#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfTotalOrdenVehiculos), 0.8*nrow(dfTotalOrdenVehiculos))  
trainingDataTotalOrdenVehiculos <- dfTotalOrdenVehiculos[trainingRowIndex, ]  
testDataTotalOrdenVehiculos  <- dfTotalOrdenVehiculos[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmTotalOrdenVehiculos <- lm(Total_Orden ~ Anio+Marca+Modelo, data=trainingDataTotalOrdenVehiculos)  
summary (lmTotalOrdenVehiculos) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfTotalOrdenVehiculos$Total_Orden, dfTotalOrdenVehiculos$Anio)
cor(dfTotalOrdenVehiculos$Total_Orden, dfTotalOrdenVehiculos$Marca)
cor(dfTotalOrdenVehiculos$Total_Orden, dfTotalOrdenVehiculos$Modelo)
cor(dfTotalOrdenVehiculos$Total_Orden, dfTotalOrdenVehiculos$Anio+dfTotalOrdenVehiculos$Marca+dfTotalOrdenVehiculos$Modelo)

##plot
dfPlotTotalOrdenVehiculos<-head(dfTotalOrdenVehiculos, 250)
scatter.smooth(x=dfPlotTotalOrdenVehiculos$Total_Orden, y=dfPlotTotalOrdenVehiculos$Anio+dfPlotTotalOrdenVehiculos$Marca+dfPlotTotalOrdenVehiculos$Modelo, main="Cantidad~Anio+Marca+Modelo")
boxplot(dfTotalOrdenVehiculos$Anio, main="Año", sub=paste("Outlier rows: ", boxplot.stats(dfTotalOrdenVehiculos$Anio)$out))
boxplot(dfTotalOrdenVehiculos$Marca, main="Marca", sub=paste("Outlier rows: ", boxplot.stats(dfTotalOrdenVehiculos$Marca)$out))
boxplot(dfTotalOrdenVehiculos$Modelo, main="Modelo", sub=paste("Outlier rows: ", boxplot.stats(dfTotalOrdenVehiculos$Modelo)$out))
#4--#####################################################################################################################
dfTotalOrdenStatus<-dbGetQuery(con=con, "select O.Total_Orden, S.NombreStatus 
                                            from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden 
                                            				inner join StatusOrden S on S.ID_StatusOrden = O.ID_StatusOrden")
#limpiar data
dfTotalOrdenStatus <- na.omit(dfTotalOrdenStatus)

#transformar data
dfTotalOrdenStatus<- transform(dfTotalOrdenStatus,NombreStatus=as.numeric(as.factor(NombreStatus)))


#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfTotalOrdenStatus), 0.8*nrow(dfTotalOrdenStatus))  
trainingDataTotalOrdenStatus <- dfTotalOrdenStatus[trainingRowIndex, ]  
testDataTotalTotalOrdenStatus  <- dfTotalOrdenStatus[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmTotalOrdenStatus <- lm(Total_Orden ~ NombreStatus, data=trainingDataTotalOrdenStatus)  
summary (lmTotalOrdenStatus) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfTotalOrdenStatus$Total_Orden, dfTotalOrdenStatus$NombreStatus)

##plot
dfPlotTotalOrdenStatus<-head(dfTotalOrdenStatus, 250)
scatter.smooth(x=dfPlotTotalOrdenStatus$Total_Orden, y=dfPlotTotalOrdenStatus$NombreStatus, main="Cantidad~Anio+Marca+Modelo")
boxplot(dfTotalOrdenStatus$NombreStatus, main="Nombre Status", sub=paste("Outlier rows: ", boxplot.stats(dfTotalOrdenStatus$NombreStatus)$out))
#5--#####################################################################################################################
dfOrdenGenero<-dbGetQuery(con=con, "select o.Total_Orden, C.Genero
                                          from Orden O inner join Clientes C on c.ID_Cliente = o.ID_Cliente")
#limpiar data
dfOrdenGenero <- na.omit(dfOrdenGenero)

#transformar data
dfOrdenGenero<- transform(dfOrdenGenero,Genero=as.numeric(as.factor(Genero)))


#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfOrdenGenero), 0.8*nrow(dfOrdenGenero))  
trainingDataOrdenGenero <- dfOrdenGenero[trainingRowIndex, ]  
testDataTotalOrdenGenero  <- dfOrdenGenero[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmOrdenGenero <- lm(Total_Orden ~ Genero , data=trainingDataOrdenGenero)  
summary (lmOrdenGenero) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfOrdenGenero$Total_Orden, dfOrdenGenero$Genero)

##plot
dfPlotOrdenGenero<-head(dfOrdenGenero, 700)
scatter.smooth(x=dfPlotOrdenGenero$Total_Orden, y=dfPlotOrdenGenero$Genero, main="Cantidad~Genero")
boxplot(dfOrdenGenero$Genero, main="Genero", sub=paste("Outlier rows: ", boxplot.stats(dfOrdenGenero$Genero)$out))
#6--#####################################################################################################################
dfDescuentoParte<-dbGetQuery(con=con, "select D.PorcentajeDescuento, P.Nombre as NombreParte
                                        from Orden O inner join Detalle_orden De on O.ID_Orden=De.ID_Orden  
                                        				inner join Descuento D on D.ID_Descuento=De.ID_Descuento
                                        				inner join Partes P on P.ID_Parte=De.ID_Parte")
#limpiar data
dfDescuentoParte <- na.omit(dfDescuentoParte)

#transformar data
dfDescuentoParte<- transform(dfDescuentoParte,NombreParte=as.numeric(as.factor(NombreParte)))


#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfDescuentoParte), 0.8*nrow(dfDescuentoParte))  
trainingDataDescuentoParte <- dfDescuentoParte[trainingRowIndex, ]  
testDataDescuentoParte  <- dfDescuentoParte[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmDescuentoParte <- lm(PorcentajeDescuento ~ NombreParte , data=trainingDataDescuentoParte)  
summary (lmDescuentoParte) 
#distPred3 <- predict(lmDescuento, testData)  # predecimos usanto test data

##analisis
#correlacion
cor(dfDescuentoParte$PorcentajeDescuento, dfDescuentoParte$NombreParte)

##plot
dfPlotDescuentoParte<-head(dfDescuentoParte, 700)
scatter.smooth(x=dfPlotDescuentoParte$PorcentajeDescuento, y=dfPlotDescuentoParte$NombreParte, main="PorcentajeDescuento~NombreParte")
boxplot(dfDescuentoParte$PorcentajeDescuento, main="Porcentaje Descuento", sub=paste("Outlier rows: ", boxplot.stats(dfDescuentoParte$PorcentajeDescuento)$out))
boxplot(dfDescuentoParte$NombreParte, main="Nombre Parte", sub=paste("Outlier rows: ", boxplot.stats(dfDescuentoParte$NombreParte)$out))
#7--#####################################################################################################################
dfcompleto<-dbGetQuery(con=con, "select O.Total_Orden,
		c.Nombre as NombreCiudad,
		R.Nombre as NombreRegion,
		P.Nombre as NombrePais,
		Pa.Nombre as NombreParte,
		Ca.Nombre as NombreCategoria,
		L.Nombre as NombreLinea,
		V.Anio,
		V.Marca,
		V.Modelo,
		S.NombreStatus
from Orden O inner join Ciudad C on O.ID_Ciudad=C.ID_Ciudad
        inner join Region R on C.ID_Region=r.ID_Region
        inner join Pais P on R.ID_Pais = p.ID_Pais
		inner join Detalle_orden De on O.ID_Orden=De.ID_Orden
		inner join Partes Pa on De.ID_Parte = Pa.ID_Parte
        inner join Categoria Ca on Pa.ID_Categoria = Ca.ID_Categoria
        inner join Linea L on Ca.ID_Linea = L.ID_Linea
		inner join Vehiculo V on De.VehiculoID = V.VehiculoID
		inner join StatusOrden S on S.ID_StatusOrden = O.ID_StatusOrden
")

#limpiar data
dfcompleto <- na.omit(dfcompleto)

#transformar data
dfcompleto<- transform(dfcompleto,NombreCiudad=as.numeric(as.factor(NombreCiudad)))
dfcompleto<- transform(dfcompleto,NombreRegion=as.numeric(as.factor(NombreRegion)))
dfcompleto<- transform(dfcompleto,NombrePais=as.numeric(as.factor(NombrePais)))
dfcompleto<- transform(dfcompleto,NombreParte=as.numeric(as.factor(NombreParte)))
dfcompleto<- transform(dfcompleto,NombreCategoria=as.numeric(as.factor(NombreCategoria)))
dfcompleto<- transform(dfcompleto,NombreLinea=as.numeric(as.factor(NombreLinea)))
dfcompleto<- transform(dfcompleto,Anio=as.numeric(as.factor(Anio)))
dfcompleto<- transform(dfcompleto,Marca=as.numeric(as.factor(Marca)))
dfcompleto<- transform(dfcompleto,Modelo=as.numeric(as.factor(Modelo)))
dfcompleto<- transform(dfcompleto,NombreStatus=as.numeric(as.factor(NombreStatus)))

#dfcompleto<-scale(dfcompleto)

#Creamos un modelo datos de train y test 80/20
set.seed(90)  

trainingRowIndex <- sample(1:nrow(dfcompleto), 0.8*nrow(dfcompleto))  
trainingDataCompleto <- dfcompleto[trainingRowIndex, ]  
testDataCompleto  <- dfcompleto[-trainingRowIndex, ]  

#tentativa de poner todo una misma escala

lmcompleto <- lm(Total_Orden ~ NombreCiudad+NombreRegion+NombrePais+NombreParte+NombreCategoria+NombreLinea+Anio+Marca+Modelo+NombreStatus , data=trainingDataCompleto)  
summary (lmcompleto) 


##plot
#lmcompleto<-head(dfDescuentoParte, 700)
scatter.smooth(x=dfcompleto$Total_Orden, y=dfcompleto$NombreCiudad+dfcompleto$NombreRegion+dfcompleto$NombrePais+dfcompleto$NombreParte+dfcompleto$NombreCategoria+dfcompleto$NombreLinea+dfcompleto$Anio+dfcompleto$Marca+dfcompleto$Modelo+dfcompleto$NombreStatus, main="Total Orden")

 
 
