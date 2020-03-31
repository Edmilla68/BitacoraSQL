Use msdb
Go

Create Procedure CreateBackUpFromAllJob
@Path VarChar(1000)  
As
Begin
Declare @JobName NVarChar(1000) = ''

Declare Cur1 Cursor For
    Select job.name 
    From sysjobs As job

Open Cur1

Fetch Next From Cur1 InTo @JobName

While( @@FETCH_STATUS = 0 )
    Begin
        Exec CreateBackUpFromJob @JobName , @Path
        Fetch Next From Cur1 InTo @JobName
    End

Close Cur1
Deallocate Cur1

End