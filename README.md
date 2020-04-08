## Start proxysql
DB name: test  
Run mysql1, mysql2 and proxysql in docker.
```
docker-compose up -d
```

##
Client (Sysbench) --> ProxySQL -> mysql1 (master) | mysql2 (mirrored data)

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

## Sysbench commands
```
Prepare data:
- make sysbench_prepare

Run queries:
- make sysbench_run

Delete prepared data:
- make sysbench cleanup
```