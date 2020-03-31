
Exec xp_cmdshell 'SQLCMD -dTERMINAL -q"Exec sp_helptext [COMISIONES_IMPO_REG]" -o"C:\nomfile.sql"'

/*
ojo para que funcione.....

ACTIVAR EN FACETS (CLICK DERECH SOBRE SERVERNAME)
OPCION CONFIGURACION DE AREA EXPUESTA O Surface Area Configuration 
PONER EN ON XPCmdShellEnabled

*/




--  ***********************************************************************************************************************************************
--  Para juntar todos los archivos en un solo archivo ejecutar la siguiente linea de ejemplo en el CMD:
--  C:\CARPETAACTUAL>for %f in (*.sql) do type "%f" >> D:\RUTA\ARCHIVO.sql
--  
--  ***********************************************************************************************************************************************