CREATE or alter VIEW VW_CantidadCotizacionEncimaPromedio
as
select pa.ID_Categoria, pa.ID_Parte, pr.Ciudad, TotalEncimaPromedio = CASE WHEN (cod.Cantidad/
(SELECT AVG(cod2.Cantidad)
FROM dbo.CotizacionDetalle cod2)) > 1
THEN 1 ELSE 0 end
from Cotizacion co
inner join PlantaReparacion pr on pr.IDPlantaReparacion = co.IDPlantaReparacion
inner join CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion
inner join Partes pa on pa.ID_Parte = cod.ID_Parte