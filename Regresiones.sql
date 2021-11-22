---total orden con geografia
select O.Total_Orden, c.Nombre as NombreCiudad, R.Nombre as NombreRegion, P.Nombre as NombrePais
from Orden O inner join Ciudad C on O.ID_Ciudad=C.ID_Ciudad
				inner join Region R on C.ID_Region=r.ID_Region
				inner join Pais P on R.ID_Pais = p.ID_Pais

--total orden con partes
select O.Total_Orden, P.Nombre as NombreParte, C.Nombre as NombreCategoria, L.Nombre as NombreLinea
from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden
				inner join Partes P on De.ID_Parte = P.ID_Parte
				inner join Categoria C on P.ID_Categoria = C.ID_Categoria
				inner join Linea L on C.ID_Linea = L.ID_Linea
--total orden con vehiculo
select O.Total_Orden, V.Anio, V.Marca, V.Modelo
from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden 
				inner join Vehiculo V on De.VehiculoID=V.VehiculoID

--total orden con status orden 
select O.Total_Orden, S.NombreStatus 
from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden 
				inner join StatusOrden S on S.ID_StatusOrden = O.ID_StatusOrden

--total orden por genero
select o.Total_Orden, C.Genero
from Orden O inner join Clientes C on c.ID_Cliente = o.ID_Cliente

				
---descuento por parte
select D.PorcentajeDescuento, P.Nombre as NombreParte
from Orden O inner join Detalle_orden De on O.ID_Orden=De.ID_Orden  
				inner join Descuento D on D.ID_Descuento=De.ID_Descuento
				inner join Partes P on P.ID_Parte=De.ID_Parte
