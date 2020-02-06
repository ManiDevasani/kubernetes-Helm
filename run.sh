#!/bin/bash
#$(aws ecr get-login --no-include-email --region ap-south-1)
helm init --service-account tiller --upgrade
helm repo add jetstack https://charts.jetstack.io
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
sleep 5
kubectl apply -f clusterissuer.yaml
sleep 20
helm install --name cert-manager --namespace cert-manager --version v0.8.1 jetstack/cert-manager --set ingressShim.defaultIssuerName=letsencrypt-prod --set ingressShim.defaultIssuerKind=ClusterIssuer
sleep 10
kubectl apply -f chatapp_ingress.yaml

