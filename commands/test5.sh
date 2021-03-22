#!/bin/sh
for i in {1..5}
docker stack deploy dt-test --compose-file docker-compose.yml
sleep 5
docker service scale dt-test_twin=0 dt-test_client=0
sleep 1
docker service scale dt-test_twin=1
sleep 5
docker service scale dt-test_client=1
sleep 100
mkdir res_$i
cd res
dt-savelogs
docker stack rm dt-test
cd ..