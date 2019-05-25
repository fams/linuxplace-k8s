#!/bin/bash - 
#===============================================================================
#
#          FILE: helm.sh
# 
#         USAGE: ./helm.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Fernando Augusto Medeiros Silva (), fams@linuxplace.com.br
#  ORGANIZATION: Linuxplace
#       CREATED: 25/05/2019 13:13
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
helmins() {
 kubectl -n kube-system create serviceaccount tiller
 kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
 helm init --service-account=tiller
}
helmdel() {
 kubectl -n kube-system delete deployment tiller-deploy
 kubectl delete clusterrolebinding tiller
 kubectl -n kube-system delete serviceaccount tiller
 
}

