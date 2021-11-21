--CANTIDAD DE STATUS POR ORDEN
select SO.NombreStatus as NombreEstatus,
sum(Do.cantidad) as Cantidad, sum(p.Precio*Do.Cantidad) as TotalVentas,
avg(DO.cantidad) as PromedioPartesCotizadas
from Orden O left join
StatusOrden SO on O.ID_StatusOrden = SO.ID_StatusOrden inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Partes P on P.ID_Parte = DO.ID_Parte
group by so.NombreStatus
go

--CATEGORIA CON TOTAL DE PARTES VENDIDAS
select cat.Nombre as NombreCategoria,
sum(Do.cantidad) as Cantidad, sum(p.Precio*Do.Cantidad) as TotalVentas,
avg(DO.cantidad) as PromedioPartesCotizadas
from Orden O inner join Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
inner join Partes P on (P.ID_Parte=DO.ID_Parte)
inner join Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
group by Cat.Nombre
go

--CANTIDAD DE DESCUENTOS APLICADOS
select de.NombreDescuento as NombreDescuento,
sum(Do.cantidad) as Cantidad, sum(p.Precio*Do.Cantidad) as TotalVentas,
avg(DO.cantidad) as PromedioPartesCotizadas
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden left join
Descuento De on DO. ID_Descuento= De.ID_Descuento join
Partes P on P.ID_Parte = DO.ID_Parte
group by de.NombreDescuento
go

--CATEGORIA CON TOTAL DE PARTES VENDIDAS Y GENERO DEL CLIENTE
select cat.Nombre as NombreCategoria, sum(Do.cantidad) as CantidadTotal,
sum(CASE WHEN Cli.Genero = 'M' THEN DO.Cantidad ELSE 0 END) as CantidadGeneroM,
sum(CASE WHEN Cli.Genero = 'F' THEN DO.Cantidad ELSE 0 END) as CantidadGeneroF
from Orden O inner join Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
inner join Partes P on (P.ID_Parte=DO.ID_Parte)
inner join Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
inner join Clientes Cli on O.ID_Cliente = Cli.ID_Cliente
group by Cat.Nombre
go

--VENTAS POR PAIS
select p.Nombre as NombrePais,
sum(Do.cantidad) as Cantidad, sum(pt.Precio*Do.Cantidad) as TotalVentas,
avg(DO.cantidad) as PromedioPartesCotizadas
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Ciudad c on c.ID_Ciudad = o.ID_Ciudad inner join
Region r on r.ID_Region = c.ID_Region inner join
Pais p on p.ID_Pais = r.ID_Pais inner join
Partes Pt on Pt.ID_Parte = DO.ID_Parte
group by p.Nombre
go

--CATEGORIA CON CANTIDAD DE STATUS POR COTIZACION
select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.status = 'Quote' THEN 1 ELSE 0 END) as StatusQuote,
SUM(CASE WHEN co.status = 'Order' THEN 1 ELSE 0 END) as StatusOrder
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
go

--CANTIDAD DE PROCESADO POR POR COTIZACION
select co.ProcesadoPor as NombreProcesado, 
sum(cod.cantidad) as Cantidad, sum(p.Precio*cod.Cantidad) as TotalVentas,
avg(cod.cantidad) as PromedioPartesCotizadas
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte
group by co.ProcesadoPor
go

--CATEGORIA CON CANTIDAD DE ORDENENES REALIZADAS POR COTIZACION
select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.OrdenRealizada = 0 THEN 1 ELSE 0 END) as OrdenNoRealizada,
SUM(CASE WHEN co.OrdenRealizada = 1 THEN 1 ELSE 0 END) as OrdenRealizada
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
go

--CATEGORIA CON CANTIDAD DE PARTES COTIZADAS POR COTIZACION
select cat.Nombre as NombreCategoria,
SUM(cod.Cantidad) as Cantidad,
sum(p.Precio*cod.Cantidad) as TotalPorParte
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
go