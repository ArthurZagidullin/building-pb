#!/bin/sh
apk update
apk upgrade
apk add build-essential
apk add autoconf
apk add libtool
apk add pkg-config
apk add cmake
apk add git

# install grpc_python_plugin
git clone --progress --verbose -b v1.33.2 https://github.com/grpc/grpc
cd grpc
git submodule update --init
cd cmake
mkdir -p cmake/build
cd cmake/build
cmake ../..
make
# export PATH
pwd
export PATH=$PATH:./grpc/cmake/build
# golang
cd ~
pwd
echo "go1.15.3"
wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz
cd /usr/local/go/src/
./make.bash
export PATH="/usr/local/go/bin:$PATH"
export GOPATH=/opt/go/
export PATH=$PATH:$GOPATH/bin
apk del .build-deps
go version
go get -u google.golang.org/g



