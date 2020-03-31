--  SQL SERVER USERS AUDIT  
  
-- Process  
--    CREATETemp TABLE for Report  
--    CREATETemp TABLE for Users  
--    CREATETemp TABLE for Roles  
--    Populate Db's   
--    Populate Users  
--    Populate Roles  
--    Iterate though each user AND update their roles into a single column for each db  
--    Return the users, their logins (reports orphaned if so) and their roles  
  
SET NOCOUNT ON  
  
DECLARE @db    				varchar(128)  
DECLARE @defdb    			varchar(64)  
DECLARE @createdate   		varchar(25)  
DECLARE @lAStmodifieddate  	varchar(25)  
DECLARE @logintype   		varchar(50)  
DECLARE @loginname   		varchar(64)  
  
CREATE TABLE #rpt  
(    
	db    				varchar(64),  
	Name              	varchar(128),  
	Loginname   		varchar(64),  
	defdb   			varchar(64),  
	CreateDate         	varchar(25),  
	LAStModifiedDate    varchar(25),  
	LoginType         	varchar(50),  
	Roles             	varchar(300)  
)  
  
CREATE TABLE #Temp_Users  
(  
Name              	varchar(128),  
Defdb   			varchar(64),  
CreateDate         	datetime,  
LAStModifiedDate    datetime,  
LoginType         	varchar(50),  
Roles             	varchar(1024),  
sid   				varbinary(64)  
  
)  
  
CREATE TABLE #Temp_Roles  
(  
Name             varchar(128),  
Role             varchar(128)  
)  


DECLARE databASes CURSOR  
FOR SELECT name FROM master..sysdatabASes  
OPEN databASes   
FETCH NEXT FROM databases INTO @db  
  
WHILE @@fetch_status = 0   
BEGIN  
DELETE  #temp_users  
INSERT INTO #Temp_Users  
EXEC('SELECT m.[Name],null AS Defdb,  m.CreateDate, m.UpdateDate,  
LoginType = CASE  
WHEN m.IsNTName = 1 THEN ''Windows Account''  
WHEN m.IsNTGroup = 1 THEN ''Windows Group''  
WHEN m.isSqlUser = 1 THEN ''SQL Server User''  
WHEN m.isAliased =1 THEN ''Aliased''    
WHEN m.isSQLRole = 1 THEN ''SQL Role''  
WHEN m.isAppRole = 1 THEN ''Application Role''  
ELSE ''Unknown''  
END,  
Roles = '''', sid  
FROM ['+@db+']..sysusers m  
WHERE m.SID IS NOT NULL AND name <> ''guest''  
ORDER BY m.Name')  
DELETE  #temp_roles  
INSERT INTO #Temp_Roles  
EXEC('SELECT MemberName = u.name, DbRole = g.name  
FROM ['+@db+']..sysusers u,['+@db+']..sysusers g,['+@db+']..sysmembers m  
WHERE   g.uid = m.groupuid  
AND g.issqlrole = 1  
AND u.uid = m.memberuid  
ORDER BY 1, 2')  
  
  
  
DECLARE @Name    varchar(128)  
DECLARE @Roles   varchar(1024)  
DECLARE @Role    varchar(128)  
  
DECLARE UserCursor CURSOR FOR  
SELECT name FROM #Temp_Users  
  
OPEN UserCursor  
FETCH NEXT FROM UserCursor INTO @Name  
  
WHILE @@FETCH_STATUS = 0  
  
BEGIN  
SET @Roles = ''  
DECLARE RoleCursor CURSOR FOR  
SELECT Role FROM #Temp_Roles WHERE Name = @Name  
  
OPEN RoleCursor  
FETCH NEXT FROM RoleCursor INTO @Role  
  
WHILE @@FETCH_STATUS = 0  
  
BEGIN  
IF (@Roles > '')  
SET @Roles = @Roles + ', '+@Role  
ELSE  
SET @Roles = @Role  
  
FETCH NEXT FROM RoleCursor INTO @Role  
  
END  
  
CLOSE RoleCursor  
DEALLOCATE RoleCursor  
  
SET    @loginname = 'ALERT ORPHANED!!!'  
SELECT @createdate = convert(varchar(25),createdate) FROM #temp_users WHERE Name = @Name  
SELECT @Lastmodifieddate = convert(varchar(25),lastmodifieddate) FROM #temp_users WHERE Name = @Name  
SELECT @logintype = logintype FROM #temp_users WHERE Name = @Name  
SELECT @defdb = dbname FROM  mASter..syslogins a, #temp_users b WHERE b.name = @name AND a.sid = b.sid  
SELECT @loginname= loginname FROM mASter..syslogins a, #temp_users b WHERE b.name = @name AND a.sid = b.sid  
  
INSERT INTO #rpt VALUES(rtrim(@db),rtrim(@name),isnull(rtrim(@loginname), 'orphaned'),rtrim(@defdb),@createdate,@lastmodifieddate,rtrim(@logintype),'public, '+rtrim(@roles))  
  
FETCH NEXT FROM UserCursor INTO @Name  
  
END  
CLOSE UserCursor  
DEALLOCATE UserCursor  
  
FETCH NEXT FROM databASes INTO @db  
END  
  
CLOSE databASes  
DEALLOCATE databASes  
PRINT '<b>'  
PRINT '<p ALIGN = "left"> Server Name: ' +convert(char(24), @@SERVERNAME)+'</P>'  
PRINT '<p ALIGN = "left"> Created by: ' + convert(char(30),SESSION_USER)+'</P>'  
PRINT '<p ALIGN = "left"> Created from: ' + convert(char(30),host_name())+'</P>'  
PRINT '<p ALIGN = "left"> Date: '+CONVERT(VARCHAR(32), getdate())+'</P>'  
PRINT '</b>'  
  
print '<p ALIGN = "left"><A HREF="http://url de referencia donde se reflejan las políticas en cuanto a usuarios</p></A> '  
select '<DIV ALIGN="center"><TABLE BORDER="1" CELLPADDING="8" CELLSPACING="0" BORDERCOLOUR="003366" WIDTH="100%">  
<TR BGCOLOR="EEEEEE"><TD CLASS="Title" COLSPAN="8" ALIGN="center"><B><h4>USERS LOGINS AND ROLES</B></h4></TD></TR>'  
union  all  
select     '<TR BGCOLOR="EEEEEE">  
<TD ALIGN="left" WIDTH="5%"><B>DATABASE</B> </TD>  
<TD ALIGN="left" WIDTH="5%"><B>USER NAME</B> </TD>  
<TD ALIGN="left" WIDTH="5%"><B>LOGIN NAME</B> </TD>  
<TD ALIGN="left" WIDTH="5%"><B>DEFAULT DB</B> </TD>'  
union all  
select  
'<TD ALIGN="left" WIDTH="5%"><B>CREATION DATE</B> </TD>  
<TD ALIGN="left" WIDTH="5%"><B>MODIFIED</B> </TD>  
<TD ALIGN="left" WIDTH="5%"><B>LOGIN TYPE</B> </TD>  
<TD ALIGN="left" WIDTH="40%"><B>ROLES</B> </TD>  
</TR>'  
  
union all  
SELECT '<TR>  
<TD>'+rtrim(db)+'</TD>  
<TD>'+rtrim(name)+'</TD>  
<TD>'+rtrim(loginname)+'</TD>  
<TD>'+rtrim(defdb)+'</TD>  
<TD>'+createdate+'</TD>  
<TD>'+lastmodifieddate+'</TD>  
<TD>'+rtrim(logintype)+' </TD>  
<TD>'+rtrim(roles)+'</TD>  
</TR>'  
FROM #rpt  
UNION ALL  
SELECT '</table>'  
  
DROP TABLE #Temp_Users  
DROP TABLE #Temp_Roles  
DROP TABLE #rpt  
  
SET NOCOUNT OFF







