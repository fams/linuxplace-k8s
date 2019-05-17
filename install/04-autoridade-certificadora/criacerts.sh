mkdir ../data/certs
cd ../data/certs
echo Config Certificadora
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

echo Crie a requisição de assinatura do certificado da CA:

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

echo Gere o certificado da CA e a chave privada:

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

echo Resultados:
ls -l ca.pem ca-key.pem

echo Crie a requisição de assinatura do certificado de cliente do admin

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "system:masters",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

echo Gere o certificado de cliente e a chave privada do admin

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

echo Resultados:
ls -lart admin*


echo "Gere um certificado e uma chave privada para cada nó worker e controller do Kubernetes: "
zone=(a b c)
for nodetype in worker controller ; do
  for count in 0 1 2; do

    instance=$nodetype-$count
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "system:nodes",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

echo Obtendo ips das instancias

EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)' \
  --zone southamerica-east1-${zone[$count]})

INTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)' \
  --zone southamerica-east1-${zone[$count]})

echo Gerando Certificado
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${IP_EXTERNO},${IP_INTERNO} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}

  done
done

echo Resultados:
ls -l worker*pem controller *pem


echo Gere um certificado e uma chave privada para o kube-controller-manager

{
echo CSR
cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF
echo Cert
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}

echo Resultados:

ls -l kube-controller-manager-key.pem kube-controller-manager.pem


echo "Crie a requisição de assinatura do certificado de cliente kube-proxy:"

{

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "system:node-proxier",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

}

echo "Gere o certificado de cliente e a chave privada do kube-proxy:"

{
echo cert
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

}

echo Resultados:
ls kube-proxy-key.pem kube-proxy.pem


echo "Gere o certificado e a chave privada do kube-scheduler:"

{

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}

echo Resultadoss:

ls  kube-scheduler-key.pem kube-scheduler.pem

echo Certificados para a api
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

echo Crie a requisição de assinatura do certificado do Servidor de API do Kubernetes:

{

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "Kubernetes",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

}

echo Gere o certificado e a chave privada do Servidor de API do Kubernetes:

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

echo Resultados:

ls -l kubernetes-key.pem kubernetes.pem
echo  The Service Account Key Pair



echo Gere o par de chaves para service-account:

{

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "Sao Paulo",
      "O": "Kubernetes",
      "OU": "Kubernetes do Jeito Dificil",
      "ST": "Sao Paulo"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

}

echo Resultados:

ls -l service-account-key.pem service-account.pem


echo Copie os certificados e chaves privadas apropriadas para cada instância de worker:

for enum in 0 1 2; do
  instance=worker-${enum}
  gcloud compute scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/ \
  --zone southamerica-east1-${zone[$enum]} 
done

echo Copie os certificados e chaves privadas apropriadas para cada instância de controladora:

for enum in 0 1 2; do
  instance=controller-${enum}
  gcloud compute scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
   ${instance}-key.pem ${instance}.pem \
   service-account-key.pem service-account.pem ${instance}:~/ \
   --zone southamerica-east1-${zone[$enum]} 
done
