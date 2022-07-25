#!/bin/bash

GO_VERSION=${GO_VERSION:-1.18.4}
GO_ARCH=${GO_ARCH:-go${GO_VERSION}.linux-amd64.tar.gz}


sudo rm -rf /usr/local/go ${HOME}/go
sed -i '/GOPATH\|GOBIN/d' ~/.bashrc

wget --show-progress --continue https://golang.org/dl/${GO_ARCH}
sudo tar -C /usr/local -xzvf ${GO_ARCH}
rm ${GO_ARCH}

mkdir -p ~/go/{bin,pkg,src}
echo "export GOPATH=\${HOME}/go" >> ~/.bashrc
echo "export GOBIN=\${GOPATH}/bin" >> ~/.bashrc 
echo "export PATH=\${PATH}:/usr/local/go/bin:\${GOBIN}" >> ~/.bashrc
sed -i -e '$a\' ~/.bashrc

go version
