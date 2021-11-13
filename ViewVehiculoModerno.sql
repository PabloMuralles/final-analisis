CREATE VIEW VW_VehiculoModerno
as
select pt.ID_Parte, cg.ID_Categoria, VehiculoModerno = CASE WHEN v.Anio > 2000 then 1 else 0 end
from Detalle_orden do
inner join Partes pt on pt.ID_Parte = do.ID_Parte
inner join Categoria cg on cg.ID_Categoria = pt.ID_Categoria
inner join Vehiculo v on v.VehiculoID = do.VehiculoID

