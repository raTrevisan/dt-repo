#!/bin/sh
for i in 1 2 3 4 5 
do
docker stack deploy dt-test_$i --compose-file docker-compose.yml
sleep 5
twin = 
docker service scale "dt-test_"$i"_twin=0" dt-test_client_$1=0
sleep 1
docker service scale dt-test_twin_$i=1
sleep 5
docker service scale dt-test_client_$i=1
echo Operation Starting, it $i
sleep 50
echo "50%"
sleep 50
echo "done"
mkdir res_$i
cd res
docker container ls --format {{.Names}} | xargs -I {} sh -c 'docker logs {} -t --details 2>&1 | tee {}.log'
docker stack rm dt-test$i
cd ..
done
