## Start proxysql
DB name: test  
Run master + mirror mysql and proxysql in docker.
```
docker-compose up -d
```

##
Client (Sysbench) --> ProxySQL -> master | mirror 

## Admin connect

```
make run_proxysql_admin
or 
mysql -h127.0.0.1 -P6032 -u<admin login> -p<admin pass> --prompt "ProxySQL Admin>"
```

## Application connect

```
make run_proxysql_client
or
mysql -h127.0.0.1 -P6033 -u<mysql user> -p<mysql password>
```

## Sandbox test
In order to make sure mirroring works correctly we can use sysbench test: 

 * Run docker (proxysql + master + mirror):
```
make run_docker 
```

 * Prepare sysbench data (sysbench creates tables and fill them up with data):   
2 tables, table size: 10000, 1 thread.
```
- make sysbench_prepare 
```
or use custom options:
```
sysbench oltp_read_write --mysql-host=<proxysql host> \
	--mysql-port=<proxy sql client port> \
	--db-driver=mysql \
	--mysql-user=<username> --mysql-password=<password> \
	--mysql-db=<dbname> --range_size=<size> \
	--table_size=<table size> --tables=<count of tables> --threads=<count of threads> --events=<count of events> \
	--rand-type=uniform prepare
```

* Run queries:  
time: 10 seconds, 2 tables, table size: 10000
```
- make sysbench_run
```
or use custom options:
```
sysbench oltp_read_write --mysql-host=<proxysql host> \
	--mysql-port=<proxy sql port> \
	--db-driver=mysql --max-requests=0 \
	--mysql-user=<username> --mysql-password=<password> \
  	--time=<time>  --db-ps-mode=disable \
	--mysql-db=test --range_size=100 \
	--threads=<count of threads> \
	--table-size=<table size> --tables=<count of tables> --range_selects=off \
	--report-interval=1 run
```

* Run python script, which compares tables from master and mirror.
```
python3 ./test_scripts/check_mirrored_tables.py --tables=2
```

* Delete prepared data:
```
- make sysbench cleanup
```

## Mirror failed test
This test control master works correctly after mirror mysql fail.

```.env
./mirror_fail_test.sh
```
