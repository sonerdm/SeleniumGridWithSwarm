#!/bin/bash

for i in $( seq 1 $machine_count ); do
    aws ec2 revoke-security-group-ingress \
        --group-id <security_group_id> \
        --protocol -1 \
        --cidr $(docker-machine ip node-$i)/32
done

for i in $( seq 1 $machine_count ); do
    docker-machine rm node-$i -y
done

aws ec2 disassociate-address --public-ip <your_elastic_ip>
