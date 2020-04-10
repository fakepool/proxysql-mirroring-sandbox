.PHONY: run_docker
run_docker:
	docker-compose up

.PHONY: down_docker
down_docker:
	docker-compose down -v --rmi local --remove-orphans
	rm -rf proxysql

.PHONY: run_proxysql_admin
run_proxysql_admin:
	mysql -h127.0.0.1 -P6032 -uradmin -pradmin --prompt "ProxySQL-docker Admin>"

.PHONY: run_proxysql_client
run_proxysql_client:
	mysql -h127.0.0.1 -P6033 -uroot -ppassword --prompt "ProxySQL-docker Client>"

.PHONY: sysbench_prepare
sysbench_prepare:
	sysbench oltp_read_write --mysql-host=127.0.0.1 \
	--mysql-port=6033 \
	--db-driver=mysql \
	--mysql-user=root --mysql-password=password \
	--mysql-db=test --range_size=100 \
	--table_size=10000 --tables=2 --threads=1 --events=0 \
	--rand-type=uniform prepare

.PHONY: sysbench_run
sysbench_run:
	sysbench oltp_read_write --mysql-host=127.0.0.1 \
	--mysql-port=6033 \
	--db-driver=mysql --max-requests=0 \
	--mysql-user=root --mysql-password=password \
  	--time=10  --db-ps-mode=disable \
	--mysql-db=test --range_size=100 \
	--threads=1 \
	--table-size=10000 --tables=2 --range_selects=off \
	--report-interval=1 run

.PHONY: sysbench_cleanup
sysbench_cleanup:
	sysbench oltp_read_write --mysql-host=127.0.0.1 \
	--mysql-port=6033 --db-driver=mysql \
	--mysql-user=root --mysql-password=password \
	--tables=2 \
	--mysql-db=test cleanup

.PHONY: master
master:
	mysql -h 127.0.0.1 -P 3306 -uroot -ppassword --prompt "master 3306>"

.PHONY: mirror
mirror:
	mysql -h 127.0.0.1 -P 3307 -uroot -ppassword --prompt "mirror 3307>"