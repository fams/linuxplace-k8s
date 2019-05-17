


echo Crie os recursos de rede do balanceador de carga externo:

{
  ENDERECO_PUBLICO_KUBERNETES=$(gcloud compute addresses describe kubernetes-the-hard-way \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)')

  gcloud compute http-health-checks create kubernetes \
    --description "Kubernetes Health Check" \
    --host "kubernetes.default.svc.cluster.local" \
    --request-path "/healthz"

  gcloud compute firewall-rules create kubernetes-the-hard-way-allow-health-check \
    --network kubernetes-the-hard-way \
    --source-ranges 209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 \
    --allow tcp

  gcloud compute target-pools create kubernetes-target-pool \
    --http-health-check kubernetes

  zone=( a b c)
  for enum in 0 1 2 ; do
    gcloud compute target-pools add-instances kubernetes-target-pool \
    --instances controller-$enum  --instances-zone=southamerica-east1-${zone[$enum]}
  done

  gcloud compute forwarding-rules create kubernetes-forwarding-rule \
    --address ${ENDERECO_PUBLICO_KUBERNETES} \
    --ports 6443 \
    --region $(gcloud config get-value compute/region) \
    --target-pool kubernetes-target-pool
}

echo Verificação

echo Recupere o endereço estático de IP do kubernetes-the-hard-way:

ENDERECO_PUBLICO_KUBERNETES=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

echo $ENDERECO_PUBLICO_KUBERNETES

echo Faça uma requisição HTTP para conseguir as informações de versão do Kubernetes:

curl --cacert ../data/certs/ca.pem https://${ENDERECO_PUBLICO_KUBERNETES}:6443/version

