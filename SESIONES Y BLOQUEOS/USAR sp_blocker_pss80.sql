-- DIRECCION DE EXPLICACION
-- http://mipapelerapersonal.blogspot.com/2013/12/como-supervisar-el-bloqueo-en-sql.html

WHILE 1=1 
BEGIN
   EXEC master.dbo.sp_blocker_pss80
   -- Or for fast mode 
   -- EXEC master.dbo.sp_blocker_pss80 @fast=1
   -- Or for latch mode 
   -- EXEC master.dbo.sp_blocker_pss80 @latch=1
   WAITFOR DELAY '00:00:15'
END
GO