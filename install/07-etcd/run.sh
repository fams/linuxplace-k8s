#!/bin/bash
zone=(a b c)
for enum in 0 1 2; do
	instance=controller-${enum}
	gcloud compute scp etcd.sh $instance: \
		--zone southamerica-east1-${zone[$enum]}
	gcloud compute ssh $instance \
		--zone southamerica-east1-${zone[$enum]} \
		--command 'sudo bash etcd.sh'

done
