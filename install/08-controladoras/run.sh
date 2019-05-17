#!/bin/bash
echo provisionando controller em cada instancia
zone=(a b c)
for enum in 0 1 2; do
	instance=controller-${enum}
	gcloud compute scp controller.sh $instance: \
		--zone southamerica-east1-${zone[$enum]}
	gcloud compute ssh $instance \
		--zone southamerica-east1-${zone[$enum]} \
		--command 'sudo bash controller.sh'
done
echo provisionando balanceador
bash local.sh

