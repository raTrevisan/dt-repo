#!/bin/sh
docker stack deploy dt-test --compose-file docker-compose.yml
sleep 5
docker service scale dt-test_twin=0 dt-test_client=0
sleep 1
docker service scale dt-test_twin=1
sleep 5
docker service scale dt-test_client=1
sleep 50
echo "50%"
sleep 50
echo "done"
mkdir res
cd res
docker container ls --format {{.Names}} | xargs -I {} sh -c 'docker logs {} -t --details 2>&1 | tee {}.log'
docker stack rm dt-test
