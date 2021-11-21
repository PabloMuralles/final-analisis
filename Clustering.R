install.packages("ggplot2")
install.packages("dplyr")
install.packages("DBI")
install.packages("factoextra") #paquete para graficar
library(ggplot2)
library(factoextra)
library(gridExtra)
library(dplyr)
library(DBI)
library(odbc)

################################Conexion db####################################

con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "LAPTOP-H0170RDM",
                 Database = "RepuestosWeb",
                 timeout = 5000)

#############################Dataframe##########################################

##CATEGORIA CON CANDIDAD DE STATUS POR ORDEN
dfOrdenesStatus <- dbGetQuery(conn = con,
                              "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN SO.ID_StatusOrden = 1 THEN 1 ELSE 0 END) as Procesado,
SUM(CASE WHEN SO.ID_StatusOrden = 2 THEN 1 ELSE 0 END) as Cancelado,
SUM(CASE WHEN SO.ID_StatusOrden = 3 THEN 1 ELSE 0 END) as Recibido,
SUM(CASE WHEN SO.ID_StatusOrden = 4 THEN 1 ELSE 0 END) as Enviado,
SUM(CASE WHEN SO.ID_StatusOrden = 5 THEN 1 ELSE 0 END) as Pagado,
SUM(CASE WHEN SO.ID_StatusOrden = 6 THEN 1 ELSE 0 END) as Ingresado
from Orden O left join
StatusOrden SO on O.ID_StatusOrden = SO.ID_StatusOrden inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfOrdenesStatus) <- dfOrdenesStatus$NombreCategoria
dfOrdenesStatus$NombreCategoria <- NULL

##CATEGORIA CON TOTAL DE PARTES VENDIDAS
dfVentas <- dbGetQuery(conn = con,
                       "select cat.Nombre as NombreCategoria,
sum(Do.cantidad) as Cantidad, sum(p.Precio*Do.Cantidad) as TotalVentas
from Orden O inner join Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
inner join Partes P on (P.ID_Parte=DO.ID_Parte)
inner join Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
group by Cat.Nombre"
)

rownames(dfVentas) <- dfVentas$NombreCategoria
dfVentas$NombreCategoria <- NULL

##CATEGORIA CON CANTIDAD DE DESCUENTOS APLLICADOS
dfDescuento <- dbGetQuery(conn = con,
                          "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN De.ID_Descuento = 1 THEN 1 ELSE 0 END) as PromocionTrupebistor,
SUM(CASE WHEN De.ID_Descuento = 2 THEN 1 ELSE 0 END) as PromocionQwicador,
SUM(CASE WHEN De.ID_Descuento = 3 THEN 1 ELSE 0 END) as PromocionThrunipaquar,
SUM(CASE WHEN De.ID_Descuento = 4 THEN 1 ELSE 0 END) as PromocionInzapefax,
SUM(CASE WHEN De.ID_Descuento = 5 THEN 1 ELSE 0 END) as PromocionUperollan,
SUM(CASE WHEN De.ID_Descuento = 6 THEN 1 ELSE 0 END) as PromocionMonvenplin,
SUM(CASE WHEN De.ID_Descuento = 7 THEN 1 ELSE 0 END) as PromocionEndwerpower,
SUM(CASE WHEN De.ID_Descuento = 8 THEN 1 ELSE 0 END) as PromocionRebanazz,
SUM(CASE WHEN De.ID_Descuento = 9 THEN 1 ELSE 0 END) as PromocionLomrobover,
SUM(CASE WHEN De.ID_Descuento = 10 THEN 1 ELSE 0 END) as PromocionQwinipilor,
SUM(CASE WHEN De.ID_Descuento = 11 THEN 1 ELSE 0 END) as PromocionRetuman,
SUM(CASE WHEN De.ID_Descuento = 12 THEN 1 ELSE 0 END) as PromocionEmmunazz,
SUM(CASE WHEN De.ID_Descuento = 13 THEN 1 ELSE 0 END) as PromocionLompebinar,
SUM(CASE WHEN De.ID_Descuento = 14 THEN 1 ELSE 0 END) as PromocionMonquestilin,
SUM(CASE WHEN De.ID_Descuento = 15 THEN 1 ELSE 0 END) as PromocionIntinaquor,
SUM(CASE WHEN De.ID_Descuento = 16 THEN 1 ELSE 0 END) as PromocionLomcadazz,
SUM(CASE WHEN De.ID_Descuento = 17 THEN 1 ELSE 0 END) as PromocionRapcadantor,
SUM(CASE WHEN De.ID_Descuento = 18 THEN 1 ELSE 0 END) as PromocionGrohupanar,
SUM(CASE WHEN De.ID_Descuento = 19 THEN 1 ELSE 0 END) as PromocionFrokilistor,
SUM(CASE WHEN De.ID_Descuento = 20 THEN 1 ELSE 0 END) as PromocionWinwerpegax,
SUM(CASE WHEN De.ID_Descuento = 21 THEN 1 ELSE 0 END) as PromocionTupkililin,
SUM(CASE WHEN De.ID_Descuento = 22 THEN 1 ELSE 0 END) as PromocionMonsipadin,
SUM(CASE WHEN De.ID_Descuento = 23 THEN 1 ELSE 0 END) as PromocionFrosipamin,
SUM(CASE WHEN De.ID_Descuento = 24 THEN 1 ELSE 0 END) as PromocionGrocadazz,
SUM(CASE WHEN De.ID_Descuento = 25 THEN 1 ELSE 0 END) as PromocionUnwerpin
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden left join
Descuento De on DO. ID_Descuento= De.ID_Descuento join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfDescuento) <- dfDescuento$NombreCategoria
dfDescuento$NombreCategoria <- NULL

##CATEGORIA POR CANTIDAD DE GENERO
dfGenero <- dbGetQuery(conn = con,
                       "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN Cli.Genero = 'M' THEN 1 ELSE 0 END) as M,
SUM(CASE WHEN Cli.Genero = 'F' THEN 1 ELSE 0 END) as F
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria inner join
Clientes Cli on O.ID_Cliente = Cli.ID_Cliente
group by cat.Nombre"
)

rownames(dfGenero) <- dfGenero$NombreCategoria
dfGenero$NombreCategoria <- NULL

##CATEGORIA CON TOTAL DE PARTES VENDIDAS Y GENERO DEL CLIENTE
dfGeneroCantidad <- dbGetQuery(conn = con,
                               "select cat.Nombre as NombreCategoria, sum(Do.cantidad) as CantidadTotal, 
sum(CASE WHEN Cli.Genero = 'M' THEN DO.Cantidad ELSE 0 END) as CantidadGeneroM,
sum(CASE WHEN Cli.Genero = 'F' THEN DO.Cantidad ELSE 0 END) as CantidadGeneroF
from Orden O inner join Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
						inner join Partes P on (P.ID_Parte=DO.ID_Parte)
						inner join Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
						inner join Clientes Cli on O.ID_Cliente = Cli.ID_Cliente
						group by Cat.Nombre"
)

rownames(dfGeneroCantidad) <- dfGeneroCantidad$NombreCategoria
dfGeneroCantidad$NombreCategoria <- NULL


##CATEGORIA CON PAIS
dfPais <- dbGetQuery(conn = con,
                     "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN p.ID_Pais = 1 THEN 1 ELSE 0 END) as Jamaica,
SUM(CASE WHEN p.ID_Pais = 2 THEN 1 ELSE 0 END) as Panama,
SUM(CASE WHEN p.ID_Pais = 3 THEN 1 ELSE 0 END) as Brasil,
SUM(CASE WHEN p.ID_Pais = 4 THEN 1 ELSE 0 END) as Guatemala,
SUM(CASE WHEN p.ID_Pais = 5 THEN 1 ELSE 0 END) as Mexico,
SUM(CASE WHEN p.ID_Pais = 6 THEN 1 ELSE 0 END) as Nicaragua,
SUM(CASE WHEN p.ID_Pais = 7 THEN 1 ELSE 0 END) as ElSalvador,
SUM(CASE WHEN p.ID_Pais = 8 THEN 1 ELSE 0 END) as Colombia,
SUM(CASE WHEN p.ID_Pais = 9 THEN 1 ELSE 0 END) as Argentina,
SUM(CASE WHEN p.ID_Pais = 10 THEN 1 ELSE 0 END) as España,
SUM(CASE WHEN p.ID_Pais = 11 THEN 1 ELSE 0 END) as EstadosUnidos,
SUM(CASE WHEN p.ID_Pais = 12 THEN 1 ELSE 0 END) as CostaRica,
SUM(CASE WHEN p.ID_Pais = 13 THEN 1 ELSE 0 END) as Belice,
SUM(CASE WHEN p.ID_Pais = 14 THEN 1 ELSE 0 END) as Honduras,
SUM(CASE WHEN p.ID_Pais = 15 THEN 1 ELSE 0 END) as Canada
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Ciudad c on c.ID_Ciudad = o.ID_Ciudad inner join
Region r on r.ID_Region = c.ID_Region inner join
Pais p on p.ID_Pais = r.ID_Pais inner join
Partes Pt on Pt.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = pt.ID_Categoria
group by cat.Nombre"
)

rownames(dfPais) <- dfPais$NombreCategoria
dfPais$NombreCategoria <- NULL


##CATEGORIA CON CANDIDAD DE STATUS POR COTIZACION
dfStatusCotizacion <- dbGetQuery(conn = con,
                                 "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.status = 'Quote' THEN 1 ELSE 0 END) as StatusQuote,
SUM(CASE WHEN co.status = 'Order' THEN 1 ELSE 0 END) as StatusOrder
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfStatusCotizacion) <- dfStatusCotizacion$NombreCategoria
dfStatusCotizacion$NombreCategoria <- NULL

##CATEGORIA CON CANTIDAD DE PROCESADO POR POR COTIZACION
dfCotizacionesProcesadas <- dbGetQuery(conn = con,
                                       "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.ProcesadoPor = 'Servicio de Integracion' THEN 1 ELSE 0 END) as ServiciodeIntegracion,
SUM(CASE WHEN co.ProcesadoPor = 'Aseguradora' THEN 1 ELSE 0 END) as Aseguradora,
SUM(CASE WHEN co.ProcesadoPor = 'Planta de Reparacion' THEN 1 ELSE 0 END) as PlantadeReparacion,
SUM(CASE WHEN co.ProcesadoPor = 'Call center' THEN 1 ELSE 0 END) as CallCenter
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfCotizacionesProcesadas) <- dfCotizacionesProcesadas$NombreCategoria
dfCotizacionesProcesadas$NombreCategoria <- NULL

##CATEGORIA CON CANTIDAD DE ORDENENES REALIZADAS POR COTIZACION
dfOrdenRealizadoCotizacion <- dbGetQuery(conn = con,
                                         "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.OrdenRealizada = 0 THEN 1 ELSE 0 END) as OrdenNoRealizada,
SUM(CASE WHEN co.OrdenRealizada = 1 THEN 1 ELSE 0 END) as OrdenRealizada
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfOrdenRealizadoCotizacion) <- dfOrdenRealizadoCotizacion$NombreCategoria
dfOrdenRealizadoCotizacion$NombreCategoria <- NULL


##CATEGORIA CON CANTIDAD DE PARTES COTIZADAS POR COTIZACION
dfPartesCotizadas <- dbGetQuery(conn = con,
                                "select cat.Nombre as NombreCategoria,
SUM(cod.Cantidad) as Cantidad,
sum(p.Precio*cod.Cantidad) as TotalPorParte
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(dfPartesCotizadas) <- dfPartesCotizadas$NombreCategoria
dfPartesCotizadas$NombreCategoria <- NULL


#######################################Clusters####################################
set.seed(123)

##CATEGORIA CON CANDIDAD DE STATUS POR ORDEN
OrdenStatus <- scale(dfOrdenesStatus) #Coloca a escala el df segun la media
OrdenStatus <- na.omit(OrdenStatus) #Omite los null al aplicar la escala

clusterk2OrdenStatus <- kmeans(OrdenStatus, 2, nstart = 25)
clusterk3OrdenStatus <- kmeans(OrdenStatus, 3, nstart = 25)
clusterk4OrdenStatus <- kmeans(OrdenStatus, 4, nstart = 25)
clusterk5OrdenStatus <- kmeans(OrdenStatus, 5, nstart = 25)

grafica1OrdenStatus <- fviz_cluster(clusterk2OrdenStatus, geom = "point", data = OrdenStatus) + ggtitle("k2")
grafica2OrdenStatus <- fviz_cluster(clusterk3OrdenStatus, geom = "point", data = OrdenStatus) + ggtitle("k3")
grafica3OrdenStatus <- fviz_cluster(clusterk4OrdenStatus, geom = "point", data = OrdenStatus) + ggtitle("k4")
grafica4OrdenStatus <- fviz_cluster(clusterk5OrdenStatus, geom = "point", data = OrdenStatus) + ggtitle("k5")

grid.arrange(grafica1OrdenStatus,
             grafica2OrdenStatus,
             grafica3OrdenStatus,
             grafica4OrdenStatus, nrow = 2)

fviz_nbclust(OrdenStatus, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

OrdenStatusCluster <- as.data.frame(clusterk4OrdenStatus$cluster)
OrdenStatusRaw <- dfOrdenesStatus

OrdenStatustst <- merge(OrdenStatusCluster, OrdenStatusRaw, by=0, all=TRUE)

names(OrdenStatustst)[2]<-"clustno"
OrdenStatustst <- subset(OrdenStatustst, select =-c(Row.names))

OrdenStatustst <- aggregate(OrdenStatustst, by=list(OrdenStatustst$clustno), FUN = mean)

fviz_cluster(clusterk4OrdenStatus, data = OrdenStatus, labelsize = 0, pointsize = 0)

ggplot(OrdenStatustst, aes(x="",y=Procesado, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OrdenStatustst, aes(x="",y=Cancelado, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OrdenStatustst, aes(x="",y=Recibido, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OrdenStatustst, aes(x="",y=Enviado, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OrdenStatustst, aes(x="",y=Pagado, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OrdenStatustst, aes(x="",y=Ingresado, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)




##CATEGORIA CON TOTAL DE PARTES VENDIDAS
ventas <- scale(dfVentas) #Coloca a escala el df segun la media
ventas <- na.omit(ventas) #Omite los null al aplicar la escala

clusterk2ventas <- kmeans(ventas, 2, nstart = 25)
clusterk3ventas <- kmeans(ventas, 3, nstart = 25)
clusterk4ventas <- kmeans(ventas, 4, nstart = 25)
clusterk5ventas <- kmeans(ventas, 5, nstart = 25)

grafica1ventas <- fviz_cluster(clusterk2ventas, geom = "point", data = ventas) + ggtitle("k2")
grafica2ventas <- fviz_cluster(clusterk3ventas, geom = "point", data = ventas) + ggtitle("k3")
grafica3ventas <- fviz_cluster(clusterk4ventas, geom = "point", data = ventas) + ggtitle("k4")
grafica4ventas <- fviz_cluster(clusterk5ventas, geom = "point", data = ventas) + ggtitle("k5")

grid.arrange(grafica1ventas,
             grafica2ventas,
             grafica3ventas,
             grafica4ventas, nrow = 2)

fviz_nbclust(ventas, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

ventasCluster <- as.data.frame(clusterk4ventas$cluster)
ventasRaw <- dfVentas

ventastst <- merge(ventasCluster, ventasRaw, by=0, all=TRUE)

names(ventastst)[2]<-"clustno"
ventastst <- subset(ventastst, select =-c(Row.names))

ventastst <- aggregate(ventastst, by=list(ventastst$clustno), FUN = mean)

fviz_cluster(clusterk4ventas, data = ventas, labelsize = 0, pointsize = 0)

ggplot(ventastst, aes(x="",y=Cantidad, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(ventastst, aes(x="",y=TotalVentas, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)




##CATEGORIA CON CANTIDAD DE DESCUENTOS APLLICADOS
descuento <- scale(dfDescuento) #Coloca a escala el df segun la media
descuento <- na.omit(descuento) #Omite los null al aplicar la escala

clusterk5descuento <- kmeans(descuento, 5, nstart = 25)
clusterk6descuento <- kmeans(descuento, 6, nstart = 25)
clusterk7descuento <- kmeans(descuento, 7, nstart = 25)
clusterk8descuento <- kmeans(descuento, 8, nstart = 25)

grafica1descuento <- fviz_cluster(clusterk5descuento, geom = "point", data = descuento) + ggtitle("k5")
grafica2descuento <- fviz_cluster(clusterk6descuento, geom = "point", data = descuento) + ggtitle("k6")
grafica3descuento <- fviz_cluster(clusterk7descuento, geom = "point", data = descuento) + ggtitle("k7")
grafica4descuento <- fviz_cluster(clusterk8descuento, geom = "point", data = descuento) + ggtitle("k8")

grid.arrange(grafica1descuento,
             grafica2descuento,
             grafica3descuento,
             grafica4descuento, nrow = 2)

fviz_nbclust(descuento, kmeans, method = "wss") +
  geom_vline(xintercept = 7, linetype = 2)

descuentoCluster <- as.data.frame(clusterk7descuento$cluster)
descuentoRaw <- dfDescuento

descuentotst <- merge(descuentoCluster, descuentoRaw, by=0, all=TRUE)

names(descuentotst)[2]<-"clustno"
descuentotst <- subset(descuentotst, select =-c(Row.names))

descuentotst <- aggregate(descuentotst, by=list(descuentotst$clustno), FUN = mean)

fviz_cluster(clusterk7descuento, data = descuento, labelsize = 0, pointsize = 0)

ggplot(descuentotst, aes(x="",y=PromocionTrupebistor, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(descuentotst, aes(x="",y=PromocionQwicador, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(descuentotst, aes(x="",y=PromocionThrunipaquar, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)




##CATEGORIA POR CANTIDAD DE GENERO

genero <- scale(dfGenero) #Coloca a escala el df segun la media
genero <- na.omit(genero) #Omite los null al aplicar la escala

clusterk2genero <- kmeans(genero, 2, nstart = 25)
clusterk3genero <- kmeans(genero, 3, nstart = 25)
clusterk4genero <- kmeans(genero, 4, nstart = 25)
clusterk5genero <- kmeans(genero, 5, nstart = 25)

grafica1genero <- fviz_cluster(clusterk2genero, geom = "point", data = genero) + ggtitle("k2")
grafica2genero <- fviz_cluster(clusterk3genero, geom = "point", data = genero) + ggtitle("k3")
grafica3genero <- fviz_cluster(clusterk4genero, geom = "point", data = genero) + ggtitle("k4")
grafica4genero <- fviz_cluster(clusterk5genero, geom = "point", data = genero) + ggtitle("k5")

grid.arrange(grafica1genero,
             grafica2genero,
             grafica3genero,
             grafica4genero, nrow = 2)

fviz_nbclust(genero, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

generoCluster <- as.data.frame(clusterk4genero$cluster)
generoRaw <- dfGenero

generotst <- merge(generoCluster, generoRaw, by=0, all=TRUE)

names(generotst)[2]<-"clustno"
generotst <- subset(generotst, select =-c(Row.names))

generotst <- aggregate(generotst, by=list(generotst$clustno), FUN = mean)

fviz_cluster(clusterk4genero, data = genero, labelsize = 0, pointsize = 0)

ggplot(generotst, aes(x="",y=M, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(generotst, aes(x="",y=F, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)




##CATEGORIA CON TOTAL DE PARTES VENDIDAS Y GENERO DEL CLIENTE


generoCantidad <- scale(dfGeneroCantidad) #Coloca a escala el df segun la media
generoCantidad <- na.omit(generoCantidad) #Omite los null al aplicar la escala

clusterk2generoCantidad <- kmeans(generoCantidad, 2, nstart = 25)
clusterk3generoCantidad <- kmeans(generoCantidad, 3, nstart = 25)
clusterk4generoCantidad <- kmeans(generoCantidad, 4, nstart = 25)
clusterk5generoCantidad <- kmeans(generoCantidad, 5, nstart = 25)

grafica1generoCantidad <- fviz_cluster(clusterk2generoCantidad, geom = "point", data = generoCantidad) + ggtitle("k2")
grafica2generoCantidad <- fviz_cluster(clusterk3generoCantidad, geom = "point", data = generoCantidad) + ggtitle("k3")
grafica3generoCantidad <- fviz_cluster(clusterk4generoCantidad, geom = "point", data = generoCantidad) + ggtitle("k4")
grafica4generoCantidad <- fviz_cluster(clusterk5generoCantidad, geom = "point", data = generoCantidad) + ggtitle("k5")

grid.arrange(grafica1generoCantidad,
             grafica2generoCantidad,
             grafica3generoCantidad,
             grafica4generoCantidad, nrow = 2)

fviz_nbclust(generoCantidad, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

generoCantidadCluster <- as.data.frame(clusterk4generoCantidad$cluster)
generoCantidadRaw <- dfGeneroCantidad

generoCantidadtst <- merge(generoCantidadCluster, generoCantidadRaw, by=0, all=TRUE)

names(generoCantidadtst)[2]<-"clustno"
generoCantidadtst <- subset(generoCantidadtst, select =-c(Row.names))

generoCantidadtst <- aggregate(generoCantidadtst, by=list(generoCantidadtst$clustno), FUN = mean)

fviz_cluster(clusterk4generoCantidad, data = generoCantidad, labelsize = 0, pointsize = 0)

ggplot(generoCantidadtst, aes(x="",y=CantidadGeneroM, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(generoCantidadtst, aes(x="",y=CantidadGeneroF, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(generoCantidadtst, aes(x="",y=CantidadTotal, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)


##CATEGORIA CON PAIS

pais <- scale(dfPais) #Coloca a escala el df segun la media
pais <- na.omit(pais) #Omite los null al aplicar la escala

clusterk2pais <- kmeans(pais, 2, nstart = 25)
clusterk3pais <- kmeans(pais, 3, nstart = 25)
clusterk4pais <- kmeans(pais, 4, nstart = 25)
clusterk5pais <- kmeans(pais, 5, nstart = 25)

grafica1pais <- fviz_cluster(clusterk2pais, geom = "point", data = pais) + ggtitle("k2")
grafica2pais <- fviz_cluster(clusterk3pais, geom = "point", data = pais) + ggtitle("k3")
grafica3pais <- fviz_cluster(clusterk4pais, geom = "point", data = pais) + ggtitle("k4")
grafica4pais <- fviz_cluster(clusterk5pais, geom = "point", data = pais) + ggtitle("k5")

grid.arrange(grafica1pais,
             grafica2pais,
             grafica3pais,
             grafica4pais, nrow = 2)

fviz_nbclust(pais, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)

paisCluster <- as.data.frame(clusterk3pais$cluster)
paisRaw <- dfPais

paistst <- merge(paisCluster, paisRaw, by=0, all=TRUE)

names(paistst)[2]<-"clustno"
paistst <- subset(paistst, select =-c(Row.names))

paistst <- aggregate(paistst, by=list(paistst$clustno), FUN = mean)

fviz_cluster(clusterk3pais, data = pais, labelsize = 0, pointsize = 0)

ggplot(paistst, aes(x="",y=Jamaica, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(paistst, aes(x="",y=Brasil, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(paistst, aes(x="",y=Panama, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)


##CATEGORIA CON CANDIDAD DE STATUS POR COTIZACION


statusCotizacion <- scale(dfStatusCotizacion) #Coloca a escala el df segun la media
statusCotizacion <- na.omit(statusCotizacion) #Omite los null al aplicar la escala

clusterk2statusCotizacion <- kmeans(statusCotizacion, 2, nstart = 25)
clusterk3statusCotizacion <- kmeans(statusCotizacion, 3, nstart = 25)
clusterk4statusCotizacion <- kmeans(statusCotizacion, 4, nstart = 25)
clusterk5statusCotizacion <- kmeans(statusCotizacion, 5, nstart = 25)

grafica1statusCotizacion <- fviz_cluster(clusterk2statusCotizacion, geom = "point", data = statusCotizacion) + ggtitle("k2")
grafica2statusCotizacion <- fviz_cluster(clusterk3statusCotizacion, geom = "point", data = statusCotizacion) + ggtitle("k3")
grafica3statusCotizacion <- fviz_cluster(clusterk4statusCotizacion, geom = "point", data = statusCotizacion) + ggtitle("k4")
grafica4statusCotizacion <- fviz_cluster(clusterk5statusCotizacion, geom = "point", data = statusCotizacion) + ggtitle("k5")

grid.arrange(grafica1statusCotizacion,
             grafica2statusCotizacion,
             grafica3statusCotizacion,
             grafica4statusCotizacion, nrow = 2)

fviz_nbclust(statusCotizacion, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

statusCotizacionCluster <- as.data.frame(clusterk4statusCotizacion$cluster)
statusCotizacionRaw <- dfStatusCotizacion

statusCotizaciontst <- merge(statusCotizacionCluster, statusCotizacionRaw, by=0, all=TRUE)

names(statusCotizaciontst)[2]<-"clustno"
statusCotizaciontst <- subset(statusCotizaciontst, select =-c(Row.names))

statusCotizaciontst <- aggregate(statusCotizaciontst, by=list(statusCotizaciontst$clustno), FUN = mean)

fviz_cluster(clusterk4statusCotizacion, data = statusCotizacion, labelsize = 0, pointsize = 0)

ggplot(statusCotizaciontst, aes(x="",y=StatusQuote, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(statusCotizaciontst, aes(x="",y=StatusOrder, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)





##CATEGORIA CON CANTIDAD DE PROCESADO POR POR COTIZACION


cotizacionesProcesadas <- scale(dfCotizacionesProcesadas) #Coloca a escala el df segun la media
cotizacionesProcesadas <- na.omit(cotizacionesProcesadas) #Omite los null al aplicar la escala

clusterk2cotizacionesProcesadas <- kmeans(cotizacionesProcesadas, 2, nstart = 25)
clusterk3cotizacionesProcesadas <- kmeans(cotizacionesProcesadas, 3, nstart = 25)
clusterk4cotizacionesProcesadas <- kmeans(cotizacionesProcesadas, 4, nstart = 25)
clusterk5cotizacionesProcesadas <- kmeans(cotizacionesProcesadas, 5, nstart = 25)

grafica1cotizacionesProcesadas <- fviz_cluster(clusterk2cotizacionesProcesadas, geom = "point", data = cotizacionesProcesadas) + ggtitle("k2")
grafica2cotizacionesProcesadas <- fviz_cluster(clusterk3cotizacionesProcesadas, geom = "point", data = cotizacionesProcesadas) + ggtitle("k3")
grafica3cotizacionesProcesadas <- fviz_cluster(clusterk4cotizacionesProcesadas, geom = "point", data = cotizacionesProcesadas) + ggtitle("k4")
grafica4cotizacionesProcesadas <- fviz_cluster(clusterk5cotizacionesProcesadas, geom = "point", data = cotizacionesProcesadas) + ggtitle("k5")

grid.arrange(grafica1cotizacionesProcesadas,
             grafica2cotizacionesProcesadas,
             grafica3cotizacionesProcesadas,
             grafica4cotizacionesProcesadas, nrow = 2)

fviz_nbclust(cotizacionesProcesadas, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

cotizacionesProcesadasCluster <- as.data.frame(clusterk4cotizacionesProcesadas$cluster)
cotizacionesProcesadasRaw <- dfCotizacionesProcesadas

cotizacionesProcesadastst <- merge(cotizacionesProcesadasCluster, cotizacionesProcesadasRaw, by=0, all=TRUE)

names(cotizacionesProcesadastst)[2]<-"clustno"
cotizacionesProcesadastst <- subset(cotizacionesProcesadastst, select =-c(Row.names))

cotizacionesProcesadastst <- aggregate(cotizacionesProcesadastst, by=list(cotizacionesProcesadastst$clustno), FUN = mean)

fviz_cluster(clusterk4cotizacionesProcesadas, data = cotizacionesProcesadas, labelsize = 0, pointsize = 0)

ggplot(cotizacionesProcesadastst, aes(x="",y=ServiciodeIntegracion, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(cotizacionesProcesadastst, aes(x="",y=Aseguradora, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(cotizacionesProcesadastst, aes(x="",y=PlantadeReparacion, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(cotizacionesProcesadastst, aes(x="",y=CallCenter, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)



##CATEGORIA CON CANTIDAD DE ORDENENES REALIZADAS POR COTIZACION

ordenesCotizacionRealizado <- scale(dfOrdenRealizadoCotizacion) #Coloca a escala el df segun la media
ordenesCotizacionRealizado <- na.omit(ordenesCotizacionRealizado) #Omite los null al aplicar la escala

clusterk2ordenesCotizacionRealizado <- kmeans(ordenesCotizacionRealizado, 2, nstart = 25)
clusterk3ordenesCotizacionRealizado <- kmeans(ordenesCotizacionRealizado, 3, nstart = 25)
clusterk4ordenesCotizacionRealizado <- kmeans(ordenesCotizacionRealizado, 4, nstart = 25)
clusterk5ordenesCotizacionRealizado <- kmeans(ordenesCotizacionRealizado, 5, nstart = 25)

grafica1ordenesCotizacionRealizado <- fviz_cluster(clusterk2ordenesCotizacionRealizado, geom = "point", data = ordenesCotizacionRealizado) + ggtitle("k2")
grafica2ordenesCotizacionRealizado <- fviz_cluster(clusterk3ordenesCotizacionRealizado, geom = "point", data = ordenesCotizacionRealizado) + ggtitle("k3")
grafica3ordenesCotizacionRealizado <- fviz_cluster(clusterk4ordenesCotizacionRealizado, geom = "point", data = ordenesCotizacionRealizado) + ggtitle("k4")
grafica4ordenesCotizacionRealizado <- fviz_cluster(clusterk5ordenesCotizacionRealizado, geom = "point", data = ordenesCotizacionRealizado) + ggtitle("k5")

grid.arrange(grafica1ordenesCotizacionRealizado,
             grafica2ordenesCotizacionRealizado,
             grafica3ordenesCotizacionRealizado,
             grafica4ordenesCotizacionRealizado, nrow = 2)

fviz_nbclust(ordenesCotizacionRealizado, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

ordenesCotizacionRealizadoCluster <- as.data.frame(clusterk4ordenesCotizacionRealizado$cluster)
ordenesCotizacionRealizadoRaw <- dfOrdenRealizadoCotizacion

ordenesCotizacionRealizadotst <- merge(ordenesCotizacionRealizadoCluster, ordenesCotizacionRealizadoRaw, by=0, all=TRUE)

names(ordenesCotizacionRealizadotst)[2]<-"clustno"
ordenesCotizacionRealizadotst <- subset(ordenesCotizacionRealizadotst, select =-c(Row.names))

ordenesCotizacionRealizadotst <- aggregate(ordenesCotizacionRealizadotst, by=list(ordenesCotizacionRealizadotst$clustno), FUN = mean)

fviz_cluster(clusterk4ordenesCotizacionRealizado, data = ordenesCotizacionRealizado, labelsize = 0, pointsize = 0)

ggplot(ordenesCotizacionRealizadotst, aes(x="",y=OrdenNoRealizada, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(ordenesCotizacionRealizadotst, aes(x="",y=OrdenRealizada, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)




##CATEGORIA CON CANTIDAD DE PARTES COTIZADAS POR COTIZACION



parteCotizada <- scale(dfPartesCotizadas) #Coloca a escala el df segun la media
parteCotizada <- na.omit(parteCotizada) #Omite los null al aplicar la escala

clusterk2parteCotizada <- kmeans(parteCotizada, 2, nstart = 25)
clusterk3parteCotizada <- kmeans(parteCotizada, 3, nstart = 25)
clusterk4parteCotizada <- kmeans(parteCotizada, 4, nstart = 25)
clusterk5parteCotizada <- kmeans(parteCotizada, 5, nstart = 25)

grafica1parteCotizada <- fviz_cluster(clusterk2parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k2")
grafica2parteCotizada <- fviz_cluster(clusterk3parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k3")
grafica3parteCotizada <- fviz_cluster(clusterk4parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k4")
grafica4parteCotizada <- fviz_cluster(clusterk5parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k5")

grid.arrange(grafica1parteCotizada,
             grafica2parteCotizada,
             grafica3parteCotizada,
             grafica4parteCotizada, nrow = 2)

fviz_nbclust(parteCotizada, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

parteCotizadaCluster <- as.data.frame(clusterk4parteCotizada$cluster)
parteCotizadaRaw <- dfPartesCotizadas

parteCotizadatst <- merge(parteCotizadaCluster, parteCotizadaRaw, by=0, all=TRUE)

names(parteCotizadatst)[2]<-"clustno"
parteCotizadatst <- subset(parteCotizadatst, select =-c(Row.names))

parteCotizadatst <- aggregate(parteCotizadatst, by=list(parteCotizadatst$clustno), FUN = mean)

fviz_cluster(clusterk4parteCotizada, data = parteCotizada, labelsize = 0, pointsize = 0)


ggplot(parteCotizadatst, aes(x="",y=Cantidad, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(parteCotizadatst, aes(x="",y=TotalPorParte, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)