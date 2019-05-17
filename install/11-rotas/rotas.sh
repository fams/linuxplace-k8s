function routes(){
zone=(a b c)
for enum in 0 1 2; do
  for type in worker controller ; do
  instance=$type-$enum
  gcloud compute instances describe ${instance} \
    --format 'value[separator=" "](networkInterfaces[0].networkIP,metadata.items[0].value)'\
    --zone southamerica-east1-${zone[$enum]}
done
done
}
routes

routes |while read host route  ; do
  nome=$( echo $route|sed -e 's/\./-/g;s/\//-/')
  gcloud compute routes create kubernetes-route-$nome \
    --network kubernetes-the-hard-way \
    --next-hop-address $host\
    --destination-range $route
done

gcloud compute routes list --filter "network: kubernetes-the-hard-way"
