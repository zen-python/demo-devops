#!/bin/bash
VERSION=$1
CIRCLE_SHA1=$2
AWS_ECR_ACCOUNT_URL=$3
AWS_ECR_REPO_NAME=$4
AWS_ECR_HELM_REPO_NAME=$5
DJANGO_SECRET_KEY=$6 
DATABASE_NAME=$7
TAG=$VERSION-${CIRCLE_SHA1:0:7}
echo "oci://$AWS_ECR_ACCOUNT_URL/$AWS_ECR_HELM_REPO_NAME"

export KUBECONFIG=$HOME/.kube/config

result=$(eval helm ls | grep demo-devops-helm) 
if [ $? -ne "0" ]; then
   helm install demo-devops-helm "oci://$AWS_ECR_ACCOUNT_URL/$AWS_ECR_HELM_REPO_NAME" \
     --set image.tag=$TAG \
     --set image.repository=$AWS_ECR_ACCOUNT_URL/$AWS_ECR_REPO_NAME \
     --version $TAG \
     --set django.secretKey=$DJANGO_SECRET_KEY \
     --set django.databaseName=$DATABASE_NAME
else
   helm upgrade demo-devops-helm "oci://$AWS_ECR_ACCOUNT_URL/$AWS_ECR_HELM_REPO_NAME" \
     --set image.tag=$TAG \
     --set image.repository=$AWS_ECR_ACCOUNT_URL/$AWS_ECR_REPO_NAME \
     --version $TAG \
     --set django.secretKey=$DJANGO_SECRET_KEY \
     --set django.databaseName=$DATABASE_NAME
fi