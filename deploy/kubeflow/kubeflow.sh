#!/bin/bash

cd "$(dirname "$0")" || exit

MANIFESTS_REPO_LINK="${MANIFESTS_REPO_LINK:-git@github.com:kubeflow/manifests.git}"
MANIFESTS_REPO_NAME="${MANIFESTS_REPO_NAME:-manifests}"
KUBEFLOW_VERSION="${KUBEFLOW_VERSION:-v1.7.0}"
KUSTOMIZE_VERSION="${KUSTOMIZE_VERSION:-3.2.0}"
K8S_VERSION="${K8S_VERSION:-1.23}"

COL_RED='\033[0;31m'
COL_WHITE='\033[0;37m'
COL_YLW='\033[0;33m'
COL_RST='\033[0m'


function download_manifests() {
  rm -rf "${MANIFESTS_REPO_NAME}"
  git clone --depth 1 --branch "${KUBEFLOW_VERSION}" "${MANIFESTS_REPO_LINK}" "${MANIFESTS_REPO_NAME}"
}

function delete_manifests() {
  rm -rf "${MANIFESTS_REPO_NAME}"
}

function check_kustomize_version() {
  local cur_kustomize_version
  cur_kustomize_version="$(kustomize version)"

  if [[ "${cur_kustomize_version}" == *["${KUSTOMIZE_VERSION}"]* ]]; then
    echo -e "${COL_WHITE}INFO${COL_RST} kustomize version: ${KUSTOMIZE_VERSION}"
  else
    echo -e "${COL_RED}ERROR${COL_RST} unsupported kustomize version. Required: ${KUSTOMIZE_VERSION}. Provided ${cur_kustomize_version}"
    exit 1
  fi
}

function check_k8s_version() {
  local cur_k8s_version
  cur_k8s_version="$(kubectl version -o json | jq -rj '.serverVersion|.major,".",.minor')"

  if [[ "${cur_k8s_version}" == "${K8S_VERSION}" ]]; then
    echo -e "${COL_WHITE}INFO${COL_RST} k8s version: ${K8S_VERSION}"
  else
    echo -e "${COL_RED}ERROR${COL_RST} unsupported k8s version. Required: ${K8S_VERSION}. Provided ${cur_k8s_version}"
    exit 1
  fi
}

function check_default_storage_class() {
  kubectl get sc -o jsonpath="{..annotations}" \
    | jq 'select(has("storageclass.kubernetes.io/is-default-class"))|.[]' \
    | jq -s 'index("true")' &> /dev/null

  if [ "$?" ]; then
    echo -e "${COL_WHITE}INFO${COL_RST} default storage class was found"
  else
    echo -e "${COL_RED}ERROR${COL_RST} default storage class was not found"
  fi
}

function install_kubeflow() {
  cd "${MANIFESTS_REPO_NAME}" || exit
  while ! kustomize build example | kubectl apply -f -; do echo -e "${COL_YLW}WARNING${COL_RST} Retrying to apply resources"; sleep 10; done
}

check_kustomize_version
check_k8s_version
check_default_storage_class
download_manifests
install_kubeflow
delete_manifests
