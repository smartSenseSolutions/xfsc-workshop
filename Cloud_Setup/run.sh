#!/bin/bash

set -x
# set -e

sudo rm -rf /usr/local/bin/minikube \
sudo rm -rf /tmp/juju-mk* \
sudo rm -rf /tmp/minikube.* \
sudo rm -rf ~/.minikube \
sudo rm -rf ~/.kube \
sudo rm -rf /var/lib/minikube/certs

sudo rm /etc/kubernetes/admin.conf

curl -LO  https://storage.googleapis.com/minikube/releases/v1.25.2/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --vm-driver=none

kubectl apply -f k8s/account.yaml

kubectl apply -f k8s/role.yaml

kubectl apply -f k8s/role-binding.yaml

export TOKENNAME=$(kubectl get serviceaccount/api-service-account -o jsonpath='{.secrets[0].name}')

export TOKEN=$(kubectl get secret $TOKENNAME -o jsonpath='{.data.token}')

sed -i "s/K8S_TOKEN:.*/K8S_TOKEN: \"$TOKEN\"/" k8s/secret.yaml

kubectl apply -f k8s/configmap.yaml

kubectl apply -f k8s/secret.yaml

kubectl apply -f k8s/pv.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

minikube addons enable ingress

kubectl apply -f k8s/issuer.yaml

kubectl apply -f k8s/deployment.yaml

kubectl apply -f k8s/service.yaml

