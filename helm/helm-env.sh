#!/bin/bash - 
#===============================================================================
#
#          FILE: helm-env.sh
# 
#         USAGE: ./helm-env.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Fernando Augusto Medeiros Silva (), fams@linuxplace.com.br
#  ORGANIZATION: Linuxplace
#       CREATED: 25/05/2019 12:55
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
cp ca.pem ~/.helm/
cp flux-helm-operator-key.pem ~/.helm/key.pem
cp flux-helm-operator.pem ~/.helm/cert.pem

export HELM_TLS_ENABLE=true
export HELM_TLS_VERIFY=true

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
