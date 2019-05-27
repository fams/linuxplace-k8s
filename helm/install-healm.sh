#!/bin/bash - 
#===============================================================================
#
#          FILE: install-healm.sh
# 
#         USAGE: ./install-healm.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Fernando Augusto Medeiros Silva (), fams@linuxplace.com.br
#  ORGANIZATION: Linuxplace
#       CREATED: 25/05/2019 04:22
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
export TILLER_HOSTNAME=tiller-deploy.kube-system
export TILLER_SERVER=server
export USER_NAME=admin-healm

mkdir tls
cd ./tls

# Prep the configuration
echo '{"CN":"CA","key":{"algo":"rsa","size":4096}}' | cfssl gencert -initca - | cfssljson -bare ca -
echo '{"signing":{"default":{"expiry":"43800h","usages":["signing","key encipherment","server auth","client auth"]}}}' > ca-config.json

# Create the tiller certificate
echo '{"CN":"'$TILLER_SERVER'","hosts":[""],"key":{"algo":"rsa","size":4096}}' | cfssl gencert \
  -config=ca-config.json -ca=ca.pem \
  -ca-key=ca-key.pem \
  -hostname="$TILLER_HOSTNAME" - | cfssljson -bare $TILLER_SERVER

# Create a client certificate
echo '{"CN":"'$USER_NAME'","hosts":[""],"key":{"algo":"rsa","size":4096}}' | cfssl gencert \
  -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem \
  -hostname="$TILLER_HOSTNAME" - | cfssljson -bare $USER_NAME

set -x
cp ca.pem ~/.helm/
cp ${USER_NAME}-key.pem ~/.helm/key.pem
cp ${USER_NAME}.pem ~/.helm/cert.pem


helmins() {
 kubectl -n kube-system create serviceaccount tiller
 kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init \
--override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}' \
--tiller-tls \
--tiller-tls-verify \
--tiller-tls-cert=server.pem \
--tiller-tls-key=server-key.pem \
--tls-ca-cert=ca.pem \
--tiller-namespace=kube-system \
--service-account=tiller \
--debug \
--upgrade
}
helmdel() {
 kubectl -n kube-system delete deployment tiller-deploy
 kubectl -n kube-system delete svc tiller-deploy
 kubectl delete clusterrolebinding tiller
 kubectl -n kube-system delete serviceaccount tiller
 
}

helmins
