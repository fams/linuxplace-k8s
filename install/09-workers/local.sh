## Verificação

echo Conecte em um dos nós de controladora:

echo Liste os nós de Kubernetes registrados:
gcloud compute ssh controller-0 \
  --command "kubectl get nodes --kubeconfig admin.kubeconfig" \
  --zone=southamerica-east1-a
zone=(a b c)
for enum in 0 1 2; do
  for type in worker ; do   
  instance=$type-${enum}
   echo  "kubectl label node --kubeconfig admin.kubeconfig $instance node-role.kubernetes.io/role=$type" >roles.cmd
  done
done
gcloud compute ssh $instance \
    --zone southamerica-east1-${zone[$enum]}  < roles.cmd

