CREATE VIEW VW_OrdenRealizadaCotizacion
as
select C.ID_Categoria, p.ID_Parte, co.ProcesadoPor, co.IDAseguradora, Co.OrdenRealizada
from Cotizacion Co inner join CotizacionDetalle CD on Co.IDCotizacion = CD.IDCotizacion
                    inner join Partes P on CD.ID_Parte=P.ID_Parte
                    inner join Categoria C on C.ID_Categoria=P.ID_Categoria
