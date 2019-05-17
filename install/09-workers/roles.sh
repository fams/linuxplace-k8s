#!/bin/bash
{
  for enum in 0 1 2 ; do
    for type in worker controller; do
      kubectl label node $type-$enum node-role.kubernetes.io/$type=true
      if [ $type == 'controller' ]; then
        kubectl label node $type-$enum node-role.kubernetes.io/master=true
        kubectl label node $type-$enum node-role.kubernetes.io/etcd=true
        kubectl taint node $type-$enum node-role.kubernetes.io/master=true:NoSchedule
      fi
    done
  done
}
