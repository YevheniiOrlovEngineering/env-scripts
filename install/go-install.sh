#!/bin/bash

cd "$(dirname "$0")" || exit

# Open a new bash session, once script finished, to enable env changes

CONFIG_FILE=${CONFIG_FILE:-${HOME}/.bashrc}

GO_VERSION=${GO_VERSION:-1.19.3}
GO_ARCH=${GO_ARCH:-go${GO_VERSION}.linux-amd64.tar.gz}
GO_ROOT=${GO_ROOT:-/usr/local/go}

sudo rm -rf "${GO_ROOT}"
sed -i '/GOPATH\|GOBIN/d' "${CONFIG_FILE}"

wget --show-progress --continue https://golang.org/dl/"${GO_ARCH}"
sudo tar -C /usr/local -xzvf "${GO_ARCH}"
rm "${GO_ARCH}"

mkdir -p ~/go/{bin,pkg,src}

sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${CONFIG_FILE}"
echo >> "${CONFIG_FILE}"
echo "export GOPATH=\${HOME}/go" >> "${CONFIG_FILE}"
echo "export GOBIN=\${GOPATH}/bin" >> "${CONFIG_FILE}"
echo "export PATH=\${PATH}:${GO_ROOT}/bin:\${GOBIN}" >> "${CONFIG_FILE}"
sed -i -e '$a\' "${CONFIG_FILE}"

"${GO_ROOT}"/bin/go version
