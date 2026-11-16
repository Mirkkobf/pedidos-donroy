-- Cómo entregar una factura o un remito a un cliente (panel de Supabase)
--
-- 1) Ver las solicitudes pendientes y el número de pedido (pedido_id) de cada una (SQL Editor):
select c.tipo, c.datos, c.created_at, p.id as pedido_id, p.codigo, p.email, p.nombre, p.localidad
from public.comprobantes c join public.pedidos p on p.id = c.pedido_id
where c.estado = 'pendiente' and p.estado = 'recibido'
order by c.created_at;
--
-- 2) Storage › bucket "comprobantes": entrar (o crear) la carpeta con el pedido_id
--    y subir el PDF. El nombre del archivo tiene que contener la palabra
--    "factura" o "remito" (por ejemplo: "Factura A 0001-00001234.pdf").
--
--    Listo: al subirlo, el comprobante queda marcado como enviado solo y el cliente
--    ve "Descargar factura" o "Descargar remito" en Mis pedidos.
--    Solo puede bajar los archivos de sus propios pedidos.
--
-- Pedidos cancelados por los clientes (para no prepararlos):
select codigo, email, nombre, localidad, cancelado_at from public.pedidos
where estado = 'cancelado' order by cancelado_at desc;
--
-- Base de clientes (correo, nombre, localidad, cantidad de pedidos, si tiene cuenta):
select * from public.clientes order by ultimo_pedido desc;
--
-- Lo que buscan y no está en el catálogo:
select lower(termino) as termino, count(*) as veces, max(created_at) as ultima
from public.busquedas_sin_resultado group by 1 order by veces desc limit 50;
