#!/bin/bash

DISABLE_STORAGECLASS=${DISABLE_STORAGECLASS:-false}

if [ ${DISABLE_STORAGECLASS} != true -a ${DISABLE_STORAGECLASS} != false ]; then
  echo 'DISABLE_STORAGECLASS should be unset or set to either "true" or "false".'
  exit 1
fi

rm -rf ${HOME}/.kube/

sudo systemctl stop ufw
sudo systemctl disable ufw

sudo kubeadm reset

# --pod-network-cidr=10.244.0.0/16 -> flannel
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 # --service-cidr=10.18.0.0/24

mkdir -p ${HOME}/.kube
sudo cp -i /etc/kubernetes/admin.conf ${KUBECONFIG}
sudo chown $(id -u):$(id -g) ${KUBECONFIG}

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

if [ ${DISABLE_STORAGECLASS} != true ]; then
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
  kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
fi
