#!/bin/bash
set -e

manager_instance=$(aws ec2 describe-instances \
    --filters Name=key-name,Values=node-1 Name=instance-state-name,Values=running \
    --query "Reservations[*].Instances[*].[InstanceId]" \
    --output text)
    
if [ -n "$manager_instance" ]; then
  echo "Selenium Grid already running..."
  exit
fi

echo "Spinning up n aws instances..."
for i in $( seq 1 $machine_count ); do
  docker-machine create --driver amazonec2 \
    --amazonec2-region "your_region" \
    --amazonec2-vpc-id "your_vpc_id" \
    --amazonec2-request-spot-instance \
    --amazonec2-spot-price "enter_spot_price" \
    --amazonec2-instance-type "enter_instance_type" \
    --amazonec2-security-group "enter_security_group" \
    --amazonec2-security-group-readonly \
    node-$i;
done
for i in $( seq 1 $machine_count ); do
  aws ec2 authorize-security-group-ingress \
      --group-id <security_group_id> \
      --protocol -1 \
      --cidr $(docker-machine ip node-$i)/32
done
echo "Initializing Swarm mode..."
for i in $( seq 1 $machine_count ); do
	if [ "$i" = "1" ]; then
  manager_ip=$(docker-machine ip node-$i)
		        eval $(docker-machine env node-$i) && \
          docker swarm init --advertise-addr "$manager_ip"
  worker_token=$(docker swarm join-token worker -q)
	else        
		        eval $(docker-machine env node-$i) && \
        docker swarm join --token "$worker_token" "$manager_ip:2377"
    fi
done
echo "Deploying Selenium Grid to http://$(docker-machine ip node-1):4444..."
eval $(docker-machine env node-1)
docker stack deploy --compose-file=docker-compose.yml grid

sleep 4m

aws ec2 associate-address --instance-id $manager_instance --public-ip <your_elastic_ip>
