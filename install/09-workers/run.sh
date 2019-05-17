#!/bin/bash
echo provisionando worker em cada instancia
zone=(a b c)
for enum in 0 1 2; do
  for type in controller ; do   
  instance=$type-${enum}
  gcloud compute scp worker.sh $instance: \
    --zone southamerica-east1-${zone[$enum]}
  gcloud compute ssh $instance \
    --zone southamerica-east1-${zone[$enum]} \
    --command 'sudo bash worker.sh'
  done
done
echo provisionando balanceador
bash local.sh

