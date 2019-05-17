name: splash
layout: true
class: center, middle, inverse

---
count:false
# Kubernetes - Sistema Operacional Distribuido
![:scale 50%](img/k8s-logo.png)
# by [@famsbh](http://twitter.com/famsbh)

---
layout: true
count:false
name: sessao
class: left, center, inverse
#.logo-linux[![Linuxplace Logo](img/linuxplace-logo-preta.png)]

---
layout: true
name: conteudo
count:false
class: left, top
.logo-linux[![Linuxplace Logo](img/linuxplace-logo-preta.png)]

---
template: splash
# Dia 3

---
template: conteudo
# Agenda
- Dia 2
 - Instalando K8s hard way
 - Namespaces e RBAC
 - Networking
 - Ingress

- Dia 3
  - Arquitetura Kubernetes Avancado
  - Logging
  - Monitoramento
  - CI/CD
  - Service MESH




---
template: conteudo
# Instalando Hard Way
- Pré-requisitos
- Ferramentas
- Recursos Computacionais
- Autoridade certificadora
- Arquivos de configuração
- Chaves de encriptação
- Subindo o ETCD
- Subindo controladoras
- Subindo Workers
- kubectl
- Rede
- AddOns
- testes
- Cleanup

https://github.com/fams/

---
# Pré-requisitos
- Instalando o gcloud
  - Instruções em https://cloud.google.com/sdk/
- gcloud init
  - Browser
  - Copiar a chave
  - Selecionar Projeto
  - Zone
- tmux

---
# Ferramentas
- Instale o cfssl
- instale o kubectl

---
# Recursos Computacionais
- Criar o VPC kubernetes-the-hard-way
- Criar a subnet para os nodes com base em 10.240.0.0/24
- Regras de firewall
- Definir ip publico

---
#Recursos Computacionais
- Criando Workers
- Criando Controllers
- teste SSH

---
# Autoridade Certificadora
- Certificados para autenticação dos servicos
- Gere o certificado da CA e a chave privada:
- Gere o certificado de cliente e a chave privada do admin
- Gere um certificado e uma chave privada para cada nó worker e controller do Kubernetes:
- Gere um certificado e uma chave privada para o kube-controller-manager
- Gere o certificado de cliente e a chave privada do kube-proxy
- Gere o certificado e a chave privada do kube-scheduler
- Gere o certificado e a chave privada do Servidor de API do Kubernetes
- Gere o par de chaves para service-account

---
#Arquivos de configuração
- Crie um arquivo kubeconfig para o kubelet de cada nó
- Crie um arquivo kubeconfig para o serviço kube-proxy
- Crie um arquivo kubeconfig para o serviço kube-controller-manager
- Crie um arquivo kubeconfig par a o serviço kube-scheduler
- Crie um arquivo kubeconfig para o usuário admin

---
#Encriptacao at rest
- Crie e copie o arquivo de encryptacao

---
# Subindo ETCD
- Download ETCD
- Instalação ETCD
- Copia dos pem
- Config do system unit
- inicio

---
# Subindo Controladoras
 - Instalando requisitos
 - Instalando Docker
 - Download e instalação dos binários
 - Configurando o CNI
 - Configurando o Kubelet
 - Configurando o kube-proxy

---
# Configurando o kubectl
 - set cluster
 - set user
 - set context default

---
# Rotas
 - Rotas para os PODS
 - GCP
 - A cargo do CNI

---
# AddOns
- DNS
- Dashboard

---
# Testes

---
template: splash
# GKE
## ou como fazer tudo isso do jeito fácil

---
