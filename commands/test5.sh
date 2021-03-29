#!/bin/sh
for i in 1 2 3 4 5 
do
docker stack deploy dt-test_$i --compose-file docker-compose.yml
sleep 5
docker service scale "dt-test_"$i"_twin=0" "dt-test_"$i"_client=0"
sleep 1
docker service scale "dt-test_"$i"_twin=1"
sleep 10
docker service scale "dt-test_"$i"_client=1"
echo Operation Starting, iteration number $i
sleep 20
echo "20%"
sleep 20
echo "40%"
sleep 20
echo "60%"
sleep 20
echo "80%"
sleep 20
echo "done"
mkdir res_$i
cd res_$i
docker container ls --format {{.Names}} | xargs -I {} sh -c 'docker logs {} -t --details 2>&1 | tee {}.log'
docker stats --no-stream > stats.log
docker stack rm dt-test$i
cd ..
done
