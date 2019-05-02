name: splash
layout: true
class: center, middle, inverse

---
count:false
# Kubernetes - Sistema Operacional Distribuido
![logo-k8s](img/k8s_logo.png)
# by [@famsbh](http://twitter.com/famsbh)

---
layout: true
name: sessao
class: left, center, inverse
#.logo-linux[![Linuxplace Logo](img/linuxplace-logo-preta.png)]

---
layout: true
name: conteudo
class: left, top
.logo-linux[![Linuxplace Logo](img/linuxplace-logo-preta.png)]

---
template: splash

# Introdução

---
template: conteudo
# Agenda
- Dia 1
 - Introdução
 - Noções Básicas de Kubernetes
 - Arquitetura K8S
 - Instalação Minikube
 - PODS
 - Health Checks
 - Labels e Selectors
 - Deployments
 - Services
 - Secrets e ConfigMaps
 - Statefull Sets

---
# Agenda
- Dia 2
 - Namespaces e RBAC
 - Helm
 - Volumes and data
 - Security
 - Networking
 - Ingress
 - Arquitetura Kubernetes Avancado
- Dia 3
 - Instalando K8s kubeadm
 - Logging
 - Monitoramento
 - CI/CD
 - Service MESH




---
template: conteudo

# Porque Kubernetes?
- Container é a chave!
  - Portaveis
  - Mais seguros
  - Orientados a applicação
  - Orientados ao desenvolvimento
- Quem gerencia os containers?
  - Você? Scripts? Um sistema próprio?

---
#  O que é Kubernetes?
- Kubernetes é um uma plataforma código aberto para orquestração de container desenvolvida pelo Google.
- É um sistema em cluster de nós distribuídos
- Plataforma centrada em containers
- Plataforma para Micro Serviços
- Plataforma Cloud portável

???
Foto do timão do kubernetes e logo do google

---

# Principios de design
 - Alta disponibilidade
  -
 - Escalabilidade
 - Segurança
 - Portabilidade
 -


---
# Sistema em cluster de nós distribuídos
- O que é cluster computacional?
 - Agrupamento de múltiplos elementos
 - Performance, disponibilidade ou âmbos
- Distribuído
 - Fracamente acoplado
 - Hardware comum
- Orquestração de container? API Declarativa

???
FIXME imagem cluster de maquinas

---
#

---
# O que Kubernetes NÃO É
- Não é um framework e não limita o tipo de workload
  - Stateless, Statefull, data-processing
- Não compila ou gerencia código fonte. Mas fornece facilidades para o CI/CD
- Não provê serviços no nível de aplicação.
  - Messageria
  - Banco de dados
  - processamento de dados distribuídos
- Não define padrão de logging, monitoramento ou alertas
 - Provê integrações e mecanismos para exportar métricas
- Não define linguagem de configuração. Provê uma API delcarativa extensível
- Não adota nenhum sistema de configuração de hardware, manutenção, gerenciamento ou resiliência para equipamentos

???
 - Embora seja mais comum os stateless e deve-se pensar bem antes de usar o statefull
 - API + ambiente para execução
 - Diferente de outros sistemas em cluster com foco em fazer com que a aplicação seja vista como única, o kubernetes É uma plicação em cluster
 - Existem boas práticas e vários projetos concorrentes. (prometheus)
 - Pensando como orquestraçã, A depois B depois C
 - Agnóstico de startup

---
template: splash
# Arquitetura
---
template conteudo

# Componentes K8S

- ETCD
- API Server
- Controllers
- Scheduler
- Kubelet
- Container Runtime

???
Fixme: desenho dos componentes

---
# API Server (control panel)
- Componente central do K8S
- Todas as compunicações internas e externas (Sem api escondida)
- RESTFull
- YAML manifests

---
# ETCD Cluster Store  (control panel)
- Base chave/valor distribuída
- Consistência sobre Disponibilidade
- RAFT Consensus
- Em caso de split não há parada dos workers

---
# Controller Manager (control panel)
- Controller dos Controllers
- Watch loop
  - Node controller
  - replicaset
  - endpoint
  -...
- Desired State

FIXME: Desenho desired state  Controler Manager

---
# Scheduler (control panel)
- Agenda Tarefas para os Worker Nodes
- Define o node a executar em um mixto de restrições e pesos. (Black Magic)
- Não executa o pod, só define o node
- Em caso de não existir um node disponível, pod ficará em pending

---
# Cloud Controller manager
- Interage com o provedor de cloud suportado
- Instances
- load balancer
- storage

# Control Panel
Fixme desenho control panel

---
# Kubelet (Worker)
- Reporta o estado de recursos para o cluster
- Verifica o que precisa ser executado
- Reporta falhas e estatísticas para a api

# Container Runtime Interface CRI (worker)
- Gerencia os containers
- Download de imagem
- Executa, para, canal de comunicação
- Varios plugins
  - Docker
  - rkt
  - containerd

---
# Other
- kube-proxy
  - Local Network
  - Services Network
  - Load Balance (ipvs, iptables)
- Kube-DNS
  - CoreDNS from CoreOS
  - Registro de serviços

# Worker Node

FIXME Desenho Worker node

---
# PODS
- Unidade minima de execução
- Executa containers
- Entregue via manifest

- Share Namespaces (FIXME Image do https://www.ianlewis.org/en/what-are-kubernetes-pods-anyway)

# PODS
- Running a container
- kubectl exec
-

---

# Arquitetura K8S


---

# Plataformas K8S Gerenciadas

---

# Provedors de infraestrutura

---

# Componentes do K8S

---

# Lab Instalação K8S

---

# Minikube

---
# Kubeadm ()

---
# YAML

---

# PODS

## Componentes
## K8S YAML
## Deployment
## Service Mesh
## Security
