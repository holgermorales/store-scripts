/*-----------------------------------------------------------------------------------------
[DEV]

- Módulo        : Store
- Autor         : holger.morales
- Fecha         : 02-07-2022
- Version       : 1.0
- Comentario    : Create tables.


[TESTER]

[ ] Aplicar pruebas de estres.
[ ] Validar objetos creados y modificado.
[ ] Población de datos.
[ ] Otros.
    - DBA - Tester :        
    - Fecha         :   
    - Comentario  : 
------------------------------------------------------------------------------------------*/



do
$$
    declare
    begin
        create table if not exists general.catalogo
        (
            id               serial       not null,
            grupo            varchar(100) not null,
            nemonico         varchar(100) not null,
            nombre           varchar(100) not null,
            descripcion      varchar(100) not null,
            visible          varchar(1)   not null,
            estado_registro  varchar(1)   not null,
            usuario_crea     varchar(100) not null,
            usuario_modifica varchar(100) not null,
            fecha_crea       varchar(100) not null,
            fecha_modifica   varchar(100) not null,
            constraint pk_catalogo primary key (id),
            CONSTRAINT u_catalogo unique (nemonico),
            constraint ck_estado_registro_catalogo check ( estado_registro::character varying = ANY
                                                           (ARRAY ['A'::character varying,'X'::character varying])),
            constraint ck_visible_catalogo check ( visible::character varying = ANY
                                                   (ARRAY ['S'::CHARACTER VARYING,'N'::CHARACTER VARYING]) )
        ) without oids;
        comment on table general.catalogo is 'Almacena el catálogo de la solución.';
        comment on column general.catalogo.id is 'Clave primaria, autogenerada';
        comment on column general.catalogo.grupo is 'Agrupación de los nemonicos, es decir el padre.';
        comment on column general.catalogo.nemonico is 'Identificación del nemónico. Único.';
        comment on column general.catalogo.nombre is 'Nombre del nemónico.';
        comment on column general.catalogo.descripcion is 'Descripción del nemónico.';
        comment on column general.catalogo.visible is 'Permite si el catálogo es visible en el cliente o usado para defaults.  [A]Registro válido. [X] registro eliminado.';
        comment on column general.catalogo.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column general.catalogo.usuario_crea is 'Login de quien crea el registro.';
        comment on column general.catalogo.usuario_modifica is 'Login de última modificación.';
        comment on column general.catalogo.fecha_crea is 'Fecha de creación del registro.';
        comment on column general.catalogo.fecha_modifica is 'Fecha de última modificación.';
    end;
$$;

do
$$
    begin
        CREATE TABLE IF NOT EXISTS kardex.producto
        (
            id                   serial           not null,
            precio               double precision not null,
            precio_venta_publico double precision not null,
            titulo               varchar(100)     not null,
            descripcion          text             not null,
            id_categoria         int              not null,
            stock                int              not null,
            estado_registro      varchar(1)       not null,
            usuario_crea         varchar(100)     not null,
            usuario_modifica     varchar(100)     not null,
            fecha_crea           varchar(100)     not null,
            fecha_modifica       varchar(100)     not null,
            constraint pk_producto primary key (id),
            constraint fk_producto_catalogo foreign key (id_categoria) references general.catalogo (id),
            constraint ck_estado_registro_catalogo check ( estado_registro::character varying = ANY
                                                           (ARRAY ['A'::character varying,'X'::character varying]))
        ) without oids;
        comment on table kardex.producto is 'Store the products.';
        comment on column kardex.producto.id is 'Identificación de la tabla. Clave primaria autogenerada';
        comment on column kardex.producto.precio is 'Precio nominal';
        comment on column kardex.producto.precio_venta_publico is 'Precio con el cual se factura.';
        comment on column kardex.producto.titulo is 'Nombre del producto.';
        comment on column kardex.producto.descripcion is 'Descipción del producto.';
        comment on column kardex.producto.id_categoria is 'Categoría del producto. Relación con general.catalogo.id';
        comment on column kardex.producto.stock is 'Disponible para facturación';
        comment on column kardex.producto.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.producto.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.producto.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.producto.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.producto.fecha_modifica is 'Fecha de última modificación.';

    end ;
$$;



do
$$
    begin
        CREATE TABLE IF NOT EXISTS kardex.galeria
        (
            id               serial           not null,
            imagen           double precision not null,
            id_producto      int              not null,
            estado_registro  varchar(1)       not null,
            usuario_crea     varchar(100)     not null,
            usuario_modifica varchar(100)     not null,
            fecha_crea       varchar(100)     not null,
            fecha_modifica   varchar(100)     not null,
            constraint pk_galeria primary key (id),
            constraint fk_galeria_producto foreign key (id) references kardex.producto (id),
            constraint ck_estado_galeria check ( estado_registro::character varying = ANY
                                                 (ARRAY ['A'::character varying,'X'::character varying]))
        ) without oids;
        comment on table kardex.galeria is 'Guarada las urls de las imagenes de un producto';
        comment on column kardex.galeria.id is 'Identificación de la tabla. Clave primaria autogenerada';
        comment on column kardex.galeria.imagen is 'Url de la imágen';
        comment on column kardex.galeria.id_producto is 'Relación lógica con kardex.producto.id';
        comment on column kardex.galeria.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.galeria.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.galeria.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.galeria.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.galeria.fecha_modifica is 'Fecha de última modificación.';
    end ;
$$;



do
$$
    begin
        create table if not exists kardex.movimiento
        (
            id                 serial           not null,
            fecha_movimiento   timestamp        not null,
            documento          varchar(100)     not null,
            referencia         varchar(100)     not null,
            descripcion        varchar(100)     not null,
            cantidad           int              not null,
            precio_unitario    double precision not null,
            precio_total       double precision not null,
            id_tipo_movimiento int              not null,
            estado_registro    varchar(1)       not null,
            usuario_crea       varchar(100)     not null,
            usuario_modifica   varchar(100)     not null,
            fecha_crea         varchar(100)     not null,
            fecha_modifica     varchar(100)     not null,
            constraint pk_movimiento primary key (id),
            constraint fk_movimiento_tipo_catalogo foreign key (id_tipo_movimiento) references general.catalogo (id),
            constraint ck_estado_movimiento check ( estado_registro::character varying = ANY
                                                    (ARRAY ['A'::character varying,'X'::character varying]))

        ) without oids;
        comment on table kardex.movimiento is 'Registra el movimiento de los produtos.';
        comment on column kardex.movimiento.fecha_movimiento is 'Fecha de ingreso o salida dependiendo el id_tipo_movimiento';
        comment on column kardex.movimiento.documento is 'Número de factura, comprobante, etc';
        comment on column kardex.movimiento.referencia is 'Referencia del movimiento.';
        comment on column kardex.movimiento.descripcion is 'Descripción del movimiento';
        comment on column kardex.movimiento.cantidad is 'Cantidad de ingreso o salida dependiendo el tipo de movimiento';
        comment on column kardex.movimiento.precio_unitario is 'Precio unitario.';
        comment on column kardex.movimiento.precio_total is 'Calculado precion unitario por cantidad';
        comment on column kardex.movimiento.id_tipo_movimiento is 'Catálogo del tipo de movimiento. Ingreso, Salida, etc';
        comment on column kardex.movimiento.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.movimiento.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.movimiento.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.movimiento.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.movimiento.fecha_modifica is 'Fecha de última modificación.';
    end;
$$;



do
$$
    begin
        create table if not exists kardex.cliente
        (
            id                     serial       not null,
            identificacion         varchar(100) not null,
            id_tipo_identificacion int          not null,
            nombres                varchar(200) not null,
            telefono               varchar(200) not null,
            direccion              varchar(100) not null,
            correo_electronico     varchar(100) not null,
            estado_registro        varchar(1)   not null,
            usuario_crea           varchar(100) not null,
            usuario_modifica       varchar(100) not null,
            fecha_crea             varchar(100) not null,
            fecha_modifica         varchar(100) not null,
            constraint pk_cliente primary key (id),
            constraint fk_cliente_tipo_identificacion foreign key (id_tipo_identificacion) references general.catalogo (id),
            constraint ck_estado_cliente check ( estado_registro::character varying = ANY
                                                 (ARRAY ['A'::character varying,'X'::character varying]))
        ) without oids;
        comment on table kardex.cliente is 'Almacena datos del cliente';
        comment on column kardex.cliente.id is 'Identificación interna del cliente.';
        comment on column kardex.cliente.id_tipo_identificacion is 'Relación lógica con catalogo.grupo=TIPO_IDENTIFICACION, cedula, ruc, sin_identificacion';
        comment on column kardex.cliente.nombres is 'Nombres del cliente.';
        comment on column kardex.cliente.telefono is 'Telefóno del cliente.';
        comment on column kardex.cliente.direccion is 'Dirección del cliente.';
        comment on column kardex.cliente.correo_electronico is 'Correo electrónico del cliente.';
        comment on column kardex.cliente.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.cliente.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.cliente.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.cliente.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.cliente.fecha_modifica is 'Fecha de última modificación.';

    end;
$$;



do
$$
    BEGIN
        create table if not exists kardex.compra
        (
            id               serial           not null,
            id_cliente       int              not null,
            fecha_compra     timestamp        not null,
            id_medio_pago    int              not null,
            total_pago       double precision not null,
            comentario       varchar(100)     not null,
            estado_registro  varchar(1)       not null,
            usuario_crea     varchar(100)     not null,
            usuario_modifica varchar(100)     not null,
            fecha_crea       varchar(100)     not null,
            fecha_modifica   varchar(100)     not null,
            constraint pk_compra primary key (id),
            constraint fk_compra_medio_pago foreign key (id_medio_pago) references general.catalogo (id),
            constraint fk_compra_cliente foreign key (id_cliente) references kardex.cliente (id),
            constraint ck_estado_compra check ( estado_registro::character varying = ANY
                                                (ARRAY ['A'::character varying,'X'::character varying]))
        ) without oids;
        comment on table kardex.compra is 'Almacena los datos de la compra.';
        comment on column kardex.compra.id is 'Clave primaria de la relación.';
        comment on column kardex.compra.id_cliente is 'Relación lógica con kardex.cliente.id.';
        comment on column kardex.compra.fecha_compra is 'Fecha de la operación.';
        comment on column kardex.compra.id_medio_pago is 'Indica la forma de pago TARJETA_CREDITO, PAYPAL, etc. Relación con general.catalogo.grupo: MEDIO_PAGO.';
        comment on column kardex.compra.total_pago is 'Total a pagar.';
        comment on column kardex.compra.comentario is 'Comentario de la compra';
        comment on column kardex.compra.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.compra.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.compra.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.compra.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.compra.fecha_modifica is 'Fecha de última modificación.';
    end ;
$$;



do
$$
    BEgin
        CREATE TABLE IF NOT EXISTS kardex.detalle_compra
        (
            id               serial           not null,
            id_compra        int              not null,
            id_producto      int              not null,
            cantidad         double precision not null,
            precio_unitario  double precision not null,
            precio_total     double precision not null,
            estado_registro  varchar(1)       not null,
            usuario_crea     varchar(100)     not null,
            usuario_modifica varchar(100)     not null,
            fecha_crea       varchar(100)     not null,
            fecha_modifica   varchar(100)     not null,
            constraint pk_detalle_compra primary key (id),
            constraint fk_detallecompra_compra foreign key (id_compra) references kardex.compra (id),
            constraint fk_detallecompra_producto foreign key (id_producto) references kardex.producto (id),
            constraint ck_estado_detalle_compra check ( estado_registro::character varying = ANY
                                                        (ARRAY ['A'::character varying,'X'::character varying]))


        ) without oids;
        comment on table kardex.detalle_compra is 'Almacena el detalla de la compra';
        comment on column kardex.detalle_compra.id is 'Identificación de la tabla.';
        comment on column kardex.detalle_compra.id_compra is 'Relación con kardex.compra.id';
        comment on column kardex.detalle_compra.id_producto is 'Relación con kardex.producto.id';
        comment on column kardex.detalle_compra.cantidad is 'Cantidad';
        comment on column kardex.detalle_compra.precio_unitario is 'Precio por producto.';
        comment on column kardex.detalle_compra.precio_total is 'Calculado.';
        comment on column kardex.detalle_compra.estado_registro is 'Estado lógica del registro. [A]Registro válido. [X] registro eliminado.';
        comment on column kardex.detalle_compra.usuario_crea is 'Login de quien crea el registro.';
        comment on column kardex.detalle_compra.usuario_modifica is 'Login de última modificación.';
        comment on column kardex.detalle_compra.fecha_crea is 'Fecha de creación del registro.';
        comment on column kardex.detalle_compra.fecha_modifica is 'Fecha de última modificación.';

    end ;
$$;
