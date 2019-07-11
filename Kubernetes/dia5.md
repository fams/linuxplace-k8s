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
# Introdução

---
template: conteudo
# Agenda
- Dia 5
  - Security
    - Introdução
    - Autenticação e Autorização
    - Network Policy
    - Cluster Components Security
    - POD Security
    - Node Security
    - Isolamento
    - Logging



---
template: splash
# Introdução

---
template: conteudo
# Aspéctos da Segurança no Kubernetes
- Configurar o Cluster de forma segura
- Proteger a applicação
- Proteger Credenciais
- Princípios
  - Segurança em Profundidade
  - Menor Privilégio
  - Limitar a superfície de ataque

---
# Vetores de Ataque
.full-image[![Containers](img/k8scomponentes-AttackVectors.png)]

---
template: splash
# Autenticação e Autorização

---
template: conteudo
# Authorization Modes
- ABAC
- RBAC
- Node Authorization
- Webhook

---
template: conteudo
# RBAC
 - Entity
 - Resource
 - Role
 - Role Binding

.half-image[![Containers](img/k8scomponentes-RBAC.png)]

???
- Entity é um usuário, app ou qualquer coisa que queira usar o recurso
- Resource Um pod, um secret, algum recurso existente no cluster
- Role Usado para definir as permissões ce acesso a Recursos
- Role Binding Liga um Entity ao Role

---

# Tipos de Role e Binding
- Role
- ClusterRole
- RoleBinding
- ClusterRoleBinding

.full-image[![Containers](img/k8scomponentes-Roles_ClusterRoles.png)]

---
# Role
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: web
  name: service-reader
rules:
- apiGroups: [""]
  verbs: ["get", "list"]
  resources: ["services"]
```

---
# RoleBinding
```bash
kubectl create rolebinding test --role=service-reader \
 --serviceaccount=web:default -n web
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
# permite os pods do ns web listarem os services no ns web
kind: RoleBinding
metadata:
  name: test
  namespace: web
subjects:
- kind: ServiceAccount
  name: default
  namespace: web
roleRef:
  kind: Role # Role ou ClusterRole
  name: service-reader # Deve casar com o nome da Role ou ClusterRole
  apiGroup: rbac.authorization.k8s.io
```

---
# Best Pratices
-  Use RBAC!

- Desabilitar o Automount

- Use ServiceAccounts Dedicados

---
template: splash
# Network Policies

---
template:conteudo
# Netwok Policies

---
template: splash
# Cluster Components Security

---
template:conteudo
# Protegendo a API


---
template: splash
# Isolamento

---
template:conteudo
# Separando serviços críticos

- O que é crítico e sensível precisa estar separado do que não é
- Sensíveis conversam com sensíveis
- Não sensíveis conversam com sensíveis de forma controlada
- Pods devem estar isolados por segurança de credenciais entre os nodes
- Node pools, taints e tolerations devem ser adotados

???

- Se você possui serviços sensíveis que não podem ser acessados por qualquer grupo, estes devem estar isolados das outras aplicações em máquinas diferentes. Para fins de exemplificação, imagine que você tenha uma solução específica cujos serviços contêm informações críticas das quais apenas um determinado squad de desenvolvimento pode ter conhecimento e/ou acesso. Nesse caso, o recomendado é que tais serviços estejam isolados em um node pool específico com credenciais de acesso específicas apenas para esse squad, de forma que, por exemplo, apenas os desenvolvedores dele poderão fazer deploy das aplicações dessa solução. Em suma, basta criar node pools específicos com credenciais específicas para abrigar o que for crítico/sensível.
- Aplicações e microsserviços que são sensíveis devem conversar apenas com serviços que são da mesma estirpe, ou seja, devem pertencer a nodes com credenciais isoladas.
- Serviços não sensíveis podem conversar com serviços sensíveis de forma selecionada à medida que for necessário. Os não sensíveis não devem exergar, de maneira alguma, todos os sensíveis. Isso deve ser feito de forma selecionada através de um "micro-gateway" que diz: "olha, você não sensível tem permissão para chegar em tais sensíveis específicos".
- Se eu der ssh num node e acessar um pod, assim corrompendo suas credenciais, os pods estando isolados eu não consigo acessar outro node.

---
