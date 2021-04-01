#!/bin/sh
for i in 1 2 3 4 5 
do
docker stack deploy dt-test_$i --compose-file docker-compose.yml
sleep 5
docker service scale "dt-test_"$i"_twin=0" "dt-test_"$i"_client_a=0" "dt-test_"$i"_client_b=0" "dt-test_"$i"_client_c=0" "dt-test_"$i"_client_d=0"
sleep 1
docker service scale "dt-test_"$i"_twin=1"
sleep 10
docker service scale "dt-test_"$i"_client_a=1" "dt-test_"$i"_client_b=1" "dt-test_"$i"_client_c=1" "dt-test_"$i"_client_d=1"
echo Operation Starting, iteration number $i
sleep 50
echo "20%"
sleep 50
echo "40%"
sleep 50
echo "60%"
sleep 50
echo "80%"
sleep 50
echo "done"
sleep 50
mkdir res_$i
cd res_$i
docker container ls --format {{.Names}} | xargs -I {} sh -c 'docker logs {} -t --details 2>&1 | tee {}.log'
docker stats --no-stream > stats.log
docker stack rm dt-test$i
cd ..
done
