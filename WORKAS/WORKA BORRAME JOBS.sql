SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:          Eduardo Milla Marquez
-- Create date:     22-04-2015
-- Description:     Este script devuelve un listado de Jobs con la
-- informacion de la programacion (Schedules) y sus respectivas frecuencias 
-- llamado en el entorno grafico (Summary Description)...
-- =============================================

USE MSDB
DECLARE
			@JOB_ID					VARCHAR(200),
			@SCHED_ID				VARCHAR(200),
			@FREQ_TYPE				INT,
			@FREQ_INTERVAL			INT,
			@FREQ_SUBDAY_TYPE		INT,
			@FREQ_SUBDAY_INTERVAL	INT,
			@FREQ_RELATIVE_INTERVAL INT,
			@FREQ_RECURRENCE_FACTOR INT,
			@ACTIVE_START_DATE		INT,
			@SCHEDULE				VARCHAR(1000),
			@SCHEDULE_DAY			VARCHAR(200),
			@START_TIME				VARCHAR(10),
			@END_TIME				VARCHAR(10)

CREATE TABLE #SCHEDULES
		(JOB_ID 					VARCHAR(200),
		SCHED_ID 					VARCHAR(200),
		JOB_NAME 					SYSNAME,
		[STATUS] 					INT,
		SCHEDULED 					INT NULL,
		schedule 					VARCHAR(1000) NULL,
		FREQ_TYPE 					INT NULL,
		FREQ_INTERVAL 				INT NULL,
		FREQ_SUBDAY_TYPE 			INT NULL,
		FREQ_SUBDAY_INTERVAL 		INT NULL,
		FREQ_RELATIVE_INTERVAL 		INT NULL,
		FREQ_RECURRENCE_FACTOR 		INT NULL,
		ACTIVE_START_DATE 			INT NULL,
		ACTIVE_END_DATE 			INT NULL,
		ACTIVE_START_TIME 			INT NULL,
		ACTIVE_END_TIME 			INT NULL,
		DATE_CREATED 				DATETIME NULL)

INSERT INTO #SCHEDULES (
		job_id,
		sched_id ,
		job_name ,
		[status] ,
		Scheduled ,
		schedule ,
		freq_type,
		freq_interval,
		freq_subday_type,
		freq_subday_interval,
		freq_relative_interval,
		freq_recurrence_factor,
		active_start_date,
		active_end_date,
		active_start_time,
		active_end_time,
		date_created)

SELECT	j.job_id,
		sched.schedule_id,
		j.name ,
		j.enabled,
		sched.enabled,
		NULL,
		sched.freq_type,
		sched.freq_interval,
		sched.freq_subday_type,
		sched.freq_subday_interval,
		sched.freq_relative_interval,
		sched.freq_recurrence_factor,
		sched.active_start_date,
		sched.active_end_date,
		sched.active_start_time,
		sched.active_end_time,
		j.date_created
FROM sysjobs j
inner join sysjobschedules s
		ON j.job_id=s.job_id
INNER JOIN dbo.sysschedules sched
		ON s.schedule_id = sched.schedule_id

--POST #2

WHILE 1=1
BEGIN
SET @SCHEDULE = ''
IF (SELECT COUNT(*) FROM #SCHEDULES WHERE scheduled=1 and schedule is null) = 0
BREAK
ELSE
BEGIN
SELECT
@job_id=job_id,
@sched_id=sched_id,
@freq_type=freq_type,
@Freq_Interval=freq_interval,
@freq_subday_type=freq_subday_type,
@freq_subday_interval=freq_subday_interval,
@freq_relative_interval=freq_relative_interval,
@freq_recurrence_factor=freq_recurrence_factor,
@active_start_date = active_start_date,
@start_time =
CASE	WHEN LEFT(active_start_time, 2) IN (22, 23) AND len(active_start_time) = 6 
			THEN convert(varchar(2), left(active_start_time, 2) - 12) + ':' + SUBSTRING(CAST(active_start_time AS CHAR),3, 2) + ' P.M'
		WHEN left(active_start_time, 2) = (12) AND len(active_start_time) = 6
			THEN cast(LEFT(active_start_time,2) as char(2))+ ':' + SUBSTRING(CAST(active_start_time AS CHAR),3, 2) + ' P.M.'
		WHEN left(active_start_time, 2) BETWEEN 13 AND 24 AND len(active_start_time) = 6
			THEN convert(varchar(2), left(active_start_time, 2) - 12) + ':' + SUBSTRING(CAST(active_start_time AS CHAR),3, 2) + ' P.M.'
		WHEN left(active_start_time, 2) IN (10, 11) AND len(active_start_time) = 6
			THEN cast(LEFT(active_start_time,2) as char(2)) + ':' + SUBSTRING(CAST(active_start_time AS CHAR),3, 2) + ' A.M.'
		WHEN active_start_time = 0
			THEN '12:00 A.M.'
		WHEN LEN(active_start_time) = 4
			THEN '12:' + convert(varchar(2), left(active_start_time, 2) ) + ' A.M.'
		WHEN  LEN(active_start_time) = 3
			THEN '12:0' + convert(varchar(2), left(active_start_time, 1) ) + ' A.M.'
		WHEN LEN(active_start_time) = 2
			THEN '12:00:' + convert(varchar(2), left(active_start_time, 2) ) + ' A.M.'
		WHEN LEN(active_start_time) = 1
			THEN '12:00:0' + convert(varchar(2), left(active_start_time, 2) ) + ' A.M.'
	ELSE
		cast(LEFT(active_start_time,1) as char(1))+ ':' + SUBSTRING(CAST(active_start_time AS CHAR),2, 2) + ' A.M.'
END,

@END_TIME= CASE WHEN left(active_end_time, 2) IN (22, 23) AND len(active_end_time) = 6
					THEN convert(varchar(2), left(active_end_time, 2) - 12) + ':' + SUBSTRING(CAST(active_end_time AS CHAR),3, 2) + ' P.M'
				WHEN left(active_end_time, 2) = (12) AND len(active_end_time) = 6
					THEN cast(LEFT(active_end_time,2) as char(2))+ ':' + SUBSTRING(CAST(active_end_time AS CHAR),3, 2) + ' P.M.'
				WHEN left(active_end_time, 2) BETWEEN 13 AND 24 AND len(active_end_time) = 6
					THEN convert(varchar(2), left(active_end_time, 2) - 12)+ ':' + SUBSTRING(CAST(active_end_time AS CHAR),3, 2) + ' P.M.'

WHEN

left(active_end_time, 2) IN (10, 11) AND len(active_end_time) = 6

THEN

cast(LEFT(active_end_time,2) as char(2))

+ ':' + SUBSTRING(CAST(active_end_time AS CHAR),3, 2) + ' A.M.'

WHEN

active_end_time = 0

THEN

'12:00 A.M.'

WHEN

LEN(active_end_time) = 4

THEN

'12:' + convert(varchar(2), left(active_end_time, 2) ) + ' A.M.'

WHEN

LEN(active_end_time) = 3

THEN

'12:0' + convert(varchar(2), left(active_end_time, 1) ) + ' A.M.'

WHEN

LEN(active_end_time) = 2

THEN

'12:00:' + convert(varchar(2), left(active_end_time, 2) ) + ' A.M.'

WHEN

LEN(active_end_time) = 1

THEN

'12:00:0' + convert(varchar(2), left(active_end_time, 2) ) + ' A.M.'

ELSE

cast(LEFT(active_end_time,1) as char(1))

+ ':' + SUBSTRING(CAST(active_end_time AS CHAR),2, 2) + ' A.M.'

END

FROM #SCHEDULES

WHERE schedule is null

AND scheduled=1	




--POST #3

 

IF EXISTS(SELECT @freq_type WHERE @freq_type in (1,64))

BEGIN

SELECT @SCHEDULE = CASE @freq_type

WHEN 1 THEN 'Occurs Once, On '+cast(@active_start_date as varchar(8))+', At '+@start_time

WHEN 64 THEN 'Occurs When SQL Server Agent Starts'

END

END

ELSE

BEGIN

IF @freq_type=4

BEGIN

SELECT @SCHEDULE = 'Occurs Every '+cast(@freq_interval as varchar(10))+' Day(s)'

END

IF @freq_type=8

BEGIN

SELECT @SCHEDULE = 'Occurs Every '+cast(@freq_recurrence_factor as varchar(3))+' Week(s)'

SELECT @schedule_day=''

IF (SELECT (convert(int,(@freq_interval/1)) % 2)) = 1

select @schedule_day = @schedule_day+'Sun'

IF (SELECT (convert(int,(@freq_interval/2)) % 2)) = 1

select @schedule_day = @schedule_day+'Mon'

IF (SELECT (convert(int,(@freq_interval/4)) % 2)) = 1

select @schedule_day = @schedule_day+'Tue'

IF (SELECT (convert(int,(@freq_interval/8)) % 2)) = 1

select @schedule_day = @schedule_day+'Wed'

IF (SELECT (convert(int,(@freq_interval/16)) % 2)) = 1

select @schedule_day = @schedule_day+'Thu'

IF (SELECT (convert(int,(@freq_interval/32)) % 2)) = 1

select @schedule_day = @schedule_day+'Fri'

IF (SELECT (convert(int,(@freq_interval/64)) % 2)) = 1

select @schedule_day = @schedule_day+'Sat'

SELECT @SCHEDULE = @SCHEDULE+', On '+@schedule_day

END

IF @freq_type=16

BEGIN

SELECT @SCHEDULE = 'Occurs Every '+cast(@freq_recurrence_factor as varchar(3))+' Month(s) on Day '+cast(@freq_interval as varchar(3))+' of that Month'

END

IF @freq_type=32

BEGIN

SELECT @SCHEDULE = CASE @freq_relative_interval

WHEN 1 THEN 'First'

WHEN 2 THEN 'Second'

WHEN 4 THEN 'Third'

WHEN 8 THEN 'Fourth'

WHEN 16 THEN 'Last'

ELSE 'Not Applicable'

END

SELECT @SCHEDULE =

CASE @freq_interval

WHEN 1 THEN 'Occurs Every '+@SCHEDULE+' Sunday of the Month'

WHEN 2 THEN 'Occurs Every '+@SCHEDULE+' Monday of the Month'

WHEN 3 THEN 'Occurs Every '+@SCHEDULE+' Tueday of the Month'

WHEN 4 THEN 'Occurs Every '+@SCHEDULE+' Wednesday of the Month'

WHEN 5 THEN 'Occurs Every '+@SCHEDULE+' Thursday of the Month'

WHEN 6 THEN 'Occurs Every '+@SCHEDULE+' Friday of the Month'

WHEN 7 THEN 'Occurs Every '+@SCHEDULE+' Saturday of the Month'

WHEN 8 THEN 'Occurs Every '+@SCHEDULE+' Day of the Month'

WHEN 9 THEN 'Occurs Every '+@SCHEDULE+' Weekday of the Month'

WHEN 10 THEN 'Occurs Every '+@SCHEDULE+' Weekend Day of the Month'

END

END

SELECT @SCHEDULE =

CASE @freq_subday_type

WHEN 1 THEN @SCHEDULE+', At '+@start_time

WHEN 2 THEN @SCHEDULE+', every '+cast(@freq_subday_interval as varchar(3))+' Second(s) Between '+@start_time+' and '+@END_TIME

WHEN 4 THEN @SCHEDULE+', every '+cast(@freq_subday_interval as varchar(3))+' Minute(s) Between '+@start_time+' and '+@END_TIME

WHEN 8 THEN @SCHEDULE+', every '+cast(@freq_subday_interval as varchar(3))+' Hour(s) Between '+@start_time+' and '+@END_TIME

END

END

END

UPDATE #SCHEDULES

SET schedule=@SCHEDULE

WHERE job_id=@job_id

AND sched_id=@sched_Id

END

SELECT job_name ,

[status] = CASE STATUS

WHEN 1 THEN 'ENABLED'

WHEN 0 THEN 'DISABLED'

ELSE ' '

END,

scheduled= case scheduled

when 1 then 'Yes'

when 0 then 'No'

else ' '

end,

schedule as 'Frequency' ,

convert(datetime, convert(varchar,active_start_date, 101)) AS schedule_start_date,

convert(datetime, convert(varchar,active_end_date, 101)) AS schedule_end_date,

date_created

FROM #schedules

WHERE scheduled=1

ORDER BY job_name

DROP TABLE #schedules

 

 