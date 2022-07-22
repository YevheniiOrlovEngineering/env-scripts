#!/bin/bash

# kubectl autocompletion
echo "source <(kubectl completion bash)" >> ${HOME}/.bashrc
echo "alias k=kubectl" >> ${HOME}/.bashrc
echo "complete -F __start_kubectl k" >> ${HOME}/.bashrc

# Show a current active git branch in the shell prompt
# add \t to below command to display current time
export PS1='\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\]\n\[\033[01;32m\]\u\[\033[01;34m\] \$\[\033[00m\] ' >> ${HOME}/.bashrc

# Shortcut for the pretty git log. Can be extended with the commit count parameter (last -10, last -35)
export "alias last='git log --graph --all --oneline --decorate '" >> ${HOME}/.bashrc
export "alias gcp='git cherry-pick'" >> ${HOME}/.bashrc
export "alias gits='git status'" >> ${HOME}/.bashrc

echo "export KUBECONFIG=\${HOME}/.kube/config" >> ${HOME}/.bashrc
echo "export SCRIPTS=$(pwd)/.." >> ~/.bashrc

echo "alias ..='cd ..'" >> ${HOME}/.bashrc
echo "alias ...='cd ../../'" >> ${HOME}/.bashrc
echo "alias ....='cd ../../../'" >> ${HOME}/.bashrc
echo "alias .....='cd ../../../../'" >> ${HOME}/.bashrc

echo "alias kpo='k get pods -A'" >> ${HOME}/.bashrc
echo "alias kdesc='k describe pods -n '" >> ${HOME}/.bashrc
echo "alias klog='k logs -n '" >> ${HOME}/.bashrc
echo "alias ktok='sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command'" >> ${HOME}/.bashrc
echo "alias kreset='sudo \${SCRIPTS}/deploy/kube-master.sh'" >> ${HOME}/.bashrc

# test internet speed connection
echo "alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'" >> ${HOME}/.bashrc

source ${HOME}/.bashrc
