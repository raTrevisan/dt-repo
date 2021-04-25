#!/bin/sh
for i in 1 2 3 4 5
do
docker stack deploy dt-test_$i --compose-file docker-compose.yml
sleep 10
docker service scale "dt-test_"$i"_twin=0" "dt-test_"$i"_client_a=0" "dt-test_"$i"_client_b=0" "dt-test_"$i"_client_c=0" "dt-test_"$i"_client_d=0"
sleep 10
docker service scale "dt-test_"$i"_twin=1"
sleep 15
docker service scale "dt-test_"$i"_client_a=1" "dt-test_"$i"_client_b=1" "dt-test_"$i"_client_c=1" "dt-test_"$i"_client_d=1" 
echo Operation Starting, iteration number $i
mkdir res_$i
cd res_$i
mkdir stats_$i
cd stats_$i
for j in $(seq 1 18) 
do
echo saving stats
docker stats --no-stream >> "stats.log"
done
cd ..
docker container ls --format {{.Names}} | xargs -I {} sh -c 'docker logs {} -t --details 2>&1 | tee {}.log'
docker stats --no-stream > stats.log
docker stack rm dt-test_$i
sleep 10
cd ..
done

