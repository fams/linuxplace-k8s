zone=(a b c)
for enum in 0 1 2; do
  instance=worker-${enum}
  gcloud -q compute instances delete  $instance \
    --zone southamerica-east1-${zone[$enum]}
  instance=controller-${enum}
  gcloud -q compute instances delete  $instance \
    --zone southamerica-east1-${zone[$enum]}
done
{
  gcloud -q compute forwarding-rules delete kubernetes-forwarding-rule \
    --region $(gcloud config get-value compute/region)

  gcloud -q compute target-pools delete kubernetes-target-pool

  gcloud -q compute http-health-checks delete kubernetes

  gcloud -q compute addresses delete kubernetes-the-hard-way
}
gcloud -q compute firewall-rules delete \
  kubernetes-the-hard-way-allow-nginx-service \
  kubernetes-the-hard-way-allow-internal \
  kubernetes-the-hard-way-allow-external \
  kubernetes-the-hard-way-allow-health-check

{
  gcloud -q compute routes delete \
    kubernetes-route-10-200-0-0-24 \
    kubernetes-route-10-200-1-0-24 \
    kubernetes-route-10-200-2-0-24 \ 
    kubernetes-route-10-200-201-0-24 \
    kubernetes-route-10-200-202-0-24 \
    kubernetes-route-10-200-203-0-24

  gcloud -q compute networks subnets delete kubernetes

  gcloud -q compute networks delete kubernetes-the-hard-way
}