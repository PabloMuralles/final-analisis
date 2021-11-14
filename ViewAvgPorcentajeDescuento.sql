CREATE VIEW VW_PorcentajeDescuentoEncimaPromedio
as
select pt.ID_Parte, pt.ID_Categoria, ci.Nombre, 
TotalEncimaPromedio = CASE WHEN (dc.PorcentajeDescuento/
(SELECT AVG(dc2.PorcentajeDescuento)
FROM dbo.Descuento dc2)) > 1
THEN 1 ELSE 0 end 
from Orden o
inner join Detalle_orden do on do.ID_Orden = o.ID_Orden
inner join Partes pt on pt.ID_Parte = do.ID_Parte
inner join Categoria cg on cg.ID_Categoria = pt.ID_Categoria
inner join Descuento dc on dc.ID_Descuento = do.ID_Descuento
inner join Ciudad ci on ci.ID_Ciudad = o.ID_Ciudad