USE [MAXIMOInterfase]
PRINT CONVERT(varchar(20),GETDATE(),108)
GO
EXEC [spu_csm_transfer_maximo_to_ofisis_revision_neptunia] '001',2019, 02
GO
EXEC [spu_csm_transfer_maximo_to_ofisis_revision_neptunia] '002',2019, 02
GO
EXEC [spu_csm_transfer_maximo_to_ofisis_revision_neptunia] '017',2019, 02
GO
PRINT CONVERT(varchar(20),GETDATE(),108)
