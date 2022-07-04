/*-----------------------------------------------------------------------------------------
[DEV]

- Módulo        : Store
- Autor         : holger.morales
- Fecha         : 02-07-2022
- Version       : 1.0
- Comentario    : Create db.


[TESTER]

[ ] Aplicar pruebas de estres.
[ ] Validar objetos creados y modificado.
[ ] Población de datos.
[ ] Otros.
    - DBA - Tester :        
    - Fecha         :   
    - Comentario  : 
------------------------------------------------------------------------------------------*/

CREATE DATABASE todo1_store WITH OWNER = 'todo1' ENCODING = 'UTF8' TABLESPACE = 'pg_default';
grant all privileges on database todo1_store to todo1;