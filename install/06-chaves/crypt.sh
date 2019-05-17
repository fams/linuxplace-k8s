#!/bin/bash
cryptdir=../data/crypt
mkdir $cryptdir

echo Crie uma chave de encriptação:

CHAVE_ENCRIPTACAO=$(head -c 32 /dev/urandom | base64)


echo Crie o arquivo de encriptação encryption-config.yaml:

cat > $cryptdir/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${CHAVE_ENCRIPTACAO}
      - identity: {}
EOF

echo Copie o arquivo de encriptação encryption-config.yaml para cada instância de controladora:
zone=( a b c )
for enum in 0 1 2 ; do
  instance=controller-${enum}
  gcloud compute scp $cryptdir/encryption-config.yaml ${instance}:~/ \
  --zone southamerica-east1-${zone[$enum]}
done
