#!/bin/bash


REGISTRY_URL=https://harbor.vismaya.local

USERNAME=admin

PASSWORD=Harbor12345

EMAIL=admin@gmail.com

REPOSITORY=harbor.vismaya.local/library

NAMESPACE=sample

sleep 3
echo "------Pulling image------"
echo ""
docker pull nginx
sleep 2
echo ""
echo "------DONE------"
sleep 2
echo ""
echo "------Login to Docker registry------"
echo ""
docker login $REGISTRY_URL -u $USERNAME -p $PASSWORD
echo ""
sleep 2
echo "------Login success------"
sleep 2
echo ""
echo "------Tagging docker images-------"
docker tag nginx:latest $REPOSITORY/nginx:latest
echo ""
sleep 2
echo "-------DONE-------"
sleep 2
echo ""
echo "------Pushing docker images-------"
echo ""
docker push $REPOSITORY/nginx:latest
echo ""
sleep 2
echo "------DONE-------"
echo ""
sleep 2
echo "------Creating namespace and secret------"
kubectl create ns $NAMESPACE
sleep 5
kubectl create secret docker-registry regcred --docker-server=$REGISTRY_URL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL -n $NAMESPACE
sleep 3
echo "------DONE-------"
sleep 3
echo "------Continue with copying certificates to the workers and deploy sample workload"