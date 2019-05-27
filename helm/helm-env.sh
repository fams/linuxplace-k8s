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
export HELM_TLS_ENABLE=true
export HELM_TLS_VERIFY=true
