/*-----------------------------------------------------------------------------------------
[DEV]

- Módulo        : Store
- Autor         : holger.morales
- Fecha         : 02-07-2022
- Version       : 1.0
- Comentario    : Create schemas.


[TESTER]

[ ] Aplicar pruebas de estres.
[ ] Validar objetos creados y modificado.
[ ] Población de datos.
[ ] Otros.
    - DBA - Tester :        
    - Fecha         :   
    - Comentario  : 
------------------------------------------------------------------------------------------*/

DO
$$
    begin
        if not exists(SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'general') then
            CREATE SCHEMA general AUTHORIZATION todo1;

            COMMENT ON SCHEMA general IS 'Schema for Catalogs.';
        end if;
    end ;
$$;


DO
$$
    begin
        if not exists(SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'kardex') then
            CREATE SCHEMA kardex AUTHORIZATION todo1;
            COMMENT ON SCHEMA kardex IS 'Schema para movimientos de un producto.';
        end if;
    end ;
$$;
