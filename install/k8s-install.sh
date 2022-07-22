#!/bin/bash

K8S_VERSION=${K8S_VERSION:-1.22.12-00}

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
sudo kubeadm reset
sudo apt-mark unhold kubectl kubeadm kubelet kubernetes-cni
sudo apt purge -y kubeadm kubectl kubelet kubernetes-cni
sudo apt autoremove -y
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube
sudo rm /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubernetes-cni kubelet=${K8S_VERSION} kubeadm=${K8S_VERSION} kubectl=${K8S_VERSION}

sudo apt-mark hold kubelet kubeadm kubectl kubernetes-cni

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

sudo modprobe br_netfilter

sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl net.bridge.bridge-nf-call-ip6tables=1

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet

sudo sysctl --system
