#!/bin/bash


export SUBNET_ID=$(terraform output -raw subnetid)
export SECURITY_GROUP_ID=$(terraform output -raw securitygroupid)
export ECS_CLUSTER_NAME=$(terraform output -raw ecs_cluster_name)
export APP_URL=$(terraform output -raw dns_name)


aws ecs run-task --task-definition updatedb_task --network-configuration "awsvpcConfiguration={subnets=["$SUBNET_ID"],securityGroups=["$SECURITY_GROUP_ID"],assignPublicIp='ENABLED'}" --cluster $ECS_CLUSTER_NAME --launch-type="FARGATE"


open $APP_URL