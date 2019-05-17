#!/bin/bash

echo Criando VPC kubernetes-the-hard-way
gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

echo Criando Subnets
gcloud compute networks subnets create kubernetes \
  --network kubernetes-the-hard-way \
  --range 10.240.0.0/24


echo Firewalll
echo Permissoes entre as redes de nodes e pods
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
  --allow tcp,udp,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

echo "Permissoes para acesso as instâncias da internet em ssh (tcp/22) e api kubernetes (tcp/6443)"

gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 0.0.0.0/0

echo verificando as redes
gcloud compute firewall-rules list --filter "network: kubernetes-the-hard-way"

echo Alocando ip publico da região/zona padrão selecionada na instalação do gcloud
echo Esse ip será usado no controller

gcloud compute addresses create kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region)

echo verificando ip
gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"


