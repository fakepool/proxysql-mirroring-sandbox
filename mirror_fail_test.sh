#!/bin/bash

# run proxysql, master and mirror mysql
docker-compose up -d

# wait enviroment setup
sleep 7

# prepare sysbench data (creates tables, fill it up with data)
make sysbench_prepare

# count of queries executed by master mysql
prepare_queries_count=$(python3 ./test_scripts/queries_count.py)

# run sysbench queries and kill mirror
(sleep 5; echo 'killing mirror'; docker kill proxysql-mirroring-sandbox_mirror_1) & sysbench_result=$(make sysbench_run | grep 'total:')

# count of queries executed by master mysql
queries_count=$(($(python3 ./test_scripts/queries_count.py)-prepare_queries_count))

make down_docker

echo '-----------test finised-----------'
echo 'master executed:'
echo $queries_count 'queries'
echo 'sysbench send:'
echo $sysbench_result 'queries'