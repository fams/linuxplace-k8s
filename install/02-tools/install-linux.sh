## Instalando o programa da autoridade certificador

echo Instalando cfssl
# Download
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

# Permissão
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

#Movendo para /usr/local/bin
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson


# Verificacao
echo Verificando
cfssl version

echo Instalando o kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl

sudo mv kubectl /usr/local/bin

echo Verificacao
kubectl version --client




