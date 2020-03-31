ALTER DATABASE rtcdyn SET EMERGENCY;
ALTER DATABASE rtcdyn SET SINGLE_USER; 
DBCC CHECKDB (rtcdyn, REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS, ALL_ERRORMSGS;
ALTER DATABASE rtcdyn REBUILD LOG ON (NAME=rtcdyn_Log, FILENAME='D:\CsData\BackendStore\rtc\dynlogpath\rtcdyn_log2.ldf') 
dbcc checkdb (rtcdyn) 
ALTER DATABASE rtcdyn SET MULTI_USER


