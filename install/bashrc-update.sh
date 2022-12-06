#!/bin/bash

cd "$(dirname "$0")" || exit

CONFIG_FILE=${CONFIG_FILE:-${HOME}/.bashrc}

echo >> "${CONFIG_FILE}"
echo "# kubectl autocompletion" >> "${CONFIG_FILE}"
echo "source <(kubectl completion bash)" >> "${CONFIG_FILE}"
echo "alias k=kubectl" >> "${CONFIG_FILE}"
echo "complete -F __start_kubectl k" >> "${CONFIG_FILE}"
echo "export KUBE_EDITOR='nano'" >> "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"

echo "# Show a current active git branch in the shell prompt" >> "${CONFIG_FILE}"
echo "# add \t to below command to display current time" >> "${CONFIG_FILE}"
echo "export PS1='\[\033[01;34m\]\w\[\033[01;33m\]\$(__git_ps1)\[\033[01;34m\]\n\[\033[01;32m\]\u\[\033[01;34m\] \$\[\033[00m\] '" >> "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"

echo "# Shortcut for the pretty git log. Can be extended with the commit count parameter (last -10, last -35)" >> "${CONFIG_FILE}"
echo "alias last='git log --graph --all --oneline --decorate '" >> "${CONFIG_FILE}"
echo "alias gcp='git cherry-pick'" >> "${CONFIG_FILE}"
echo "alias gits='git status'" >> "${CONFIG_FILE}"
echo "alias gitc='git checkout'" >> "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"

echo "export KUBECONFIG=\${HOME}/.kube/config" >> "${CONFIG_FILE}"
echo "export SCRIPTS=$(pwd)/.." >> ~/.bashrc
echo >> "${CONFIG_FILE}"

echo "alias ..='cd ..'" >> "${CONFIG_FILE}"
echo "alias ...='cd ../../'" >> "${CONFIG_FILE}"
echo "alias ....='cd ../../../'" >> "${CONFIG_FILE}"
echo "alias .....='cd ../../../../'" >> "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"

echo "alias kpo='k get pods -A'" >> "${CONFIG_FILE}"
echo "alias kdesc='k describe pods -n '" >> "${CONFIG_FILE}"
echo "alias klog='k logs -n '" >> "${CONFIG_FILE}"
echo "alias ktok='sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command'" >> "${CONFIG_FILE}"
echo "alias kreset='\${SCRIPTS}/deploy/kubernetes/kube-master.sh'" >> "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"

echo "# test internet speed connection" >> "${CONFIG_FILE}"
echo "alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'" >> "${CONFIG_FILE}"

source "${CONFIG_FILE}"
