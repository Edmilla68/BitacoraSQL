SELECT * , cntr_value AS 'Total Server Memory (KB)'
FROM sys.dm_os_performance_counters --order by counter_name
WHERE counter_name = 'Total Server Memory (KB)'