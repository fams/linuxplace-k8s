#!/bin/bash
echo Gerando Arquivos de Configuração do Kubernetes para Autenticação
confdir=../data/config
certdir=../data/certs
mkdir $confdir
zone=( a b c)


ENDERECO_PUBLICO_KUBERNETES=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

echo Crie um arquivo kubeconfig para o kuberlet de cada nó :

for nodetype in controller worker; do
  for enum in 0 1 2; do
    instance=$nodetype-$enum
    kubectl config set-cluster kubernetes-the-hard-way \
      --certificate-authority=${certdir}/ca.pem \
      --embed-certs=true \
      --server=https://${ENDERECO_PUBLICO_KUBERNETES}:6443 \
      --kubeconfig=$confdir/${instance}.kubeconfig

    kubectl config set-credentials system:node:${instance} \
      --client-certificate=${certdir}/${instance}.pem \
      --client-key=${certdir}/${instance}-key.pem \
      --embed-certs=true \
      --kubeconfig=$confdir/${instance}.kubeconfig

    kubectl config set-context default \
      --cluster=kubernetes-the-hard-way \
      --user=system:node:${instance} \
      --kubeconfig=$confdir/${instance}.kubeconfig

    kubectl config use-context default --kubeconfig=$confdir/${instance}.kubeconfig
  done
done


echo Resultados
ls $confdir/{worker-0.kubeconfig,worker-1.kubeconfig,worker-2.kubeconfig,controller-0.kubeconfig,controller-1.kubeconfig,controller-2.kubeconfig}

echo Crie um arquivo kubeconfig para o serviço kube-proxy:

{
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${certdir}/ca.pem \
  --embed-certs=true \
  --server=https://${ENDERECO_PUBLICO_KUBERNETES}:6443 \
  --kubeconfig=$confdir/kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=${certdir}/kube-proxy.pem \
  --client-key=${certdir}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=$confdir/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=kube-proxy \
  --kubeconfig=$confdir/kube-proxy.kubeconfig


kubectl config use-context default --kubeconfig=$confdir/kube-proxy.kubeconfig

}

Resultados:

ls -l $confdir/kube-proxy.kubeconfig



echo Crie um arquivo kubeconfig para o serviço kube-controller-manager :

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${certdir}/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$confdir/kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=${certdir}/kube-controller-manager.pem \
    --client-key=${certdir}/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=$confdir/kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=$confdir/kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=$confdir/kube-controller-manager.kubeconfig
}

echo Resultados:

ls -l $confdir/kube-controller-manager.kubeconfig

echo Crie um arquivo kubeconfig par a o serviço kube-scheduler:

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${certdir}/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$confdir/kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=${certdir}/kube-scheduler.pem \
    --client-key=${certdir}/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=$confdir/kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=$confdir/kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=$confdir/kube-scheduler.kubeconfig
}


echo Resultados

ls -l $confdir/kube-scheduler.kubeconfig

echo Crie um arquivo kubeconfig para o usuário admin:

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${certdir}/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$confdir/admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=${certdir}/admin.pem \
    --client-key=${certdir}/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=$confdir/admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=$confdir/admin.kubeconfig

  kubectl config use-context default --kubeconfig=$confdir/admin.kubeconfig
}

echo Resultados:

ls -l $confdir/admin.kubeconfig


echo Copie os arquivos kubeconfig kubelet e kube-proxy apropriados para cada instância todas as instâncias:

for nodetype in controller worker; do
  for enum in 0 1 2; do
    instance=$nodetype-$enum
    gcloud compute scp $confdir/${instance}.kubeconfig $confdir/kube-proxy.kubeconfig ${instance}:~/ \
    --zone southamerica-east1-${zone[$enum]}
  done
done

echo Copie os  arquivos kubeconfig de kube-controller-manager e kube-scheduler para cada instância controller:

for enum in 0 1 2; do
  instance=controller-${enum}
  gcloud compute scp $confdir/admin.kubeconfig $confdir/kube-controller-manager.kubeconfig \
  $confdir/kube-scheduler.kubeconfig ${instance}:~/ \
    --zone southamerica-east1-${zone[$enum]}
done


