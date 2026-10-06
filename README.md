# Mundo Escolar Bookstore

Proyecto de base de datos relacional para Mundo Escolar Bookstore.

## Estructura

- `database/baseline/`: DDL físico consolidado de referencia.
- `database/deploy/`: scripts incrementales de despliegue.
- `database/test/`: scripts de validación.
- `docs/database/`: documentación técnica de la base de datos.
- `docs/execution-log/`: evidencia de ejecución por checkpoint.
- `docs/decisions/`: decisiones de diseño y arquitectura.

## Entorno actual

- SQL Server
- Database: `MundoEscolar`
- Physical root: `C:\SQLData\MundoEscolar`
- Recovery model: `FULL`
- Default filegroup: `FG_DATA`
