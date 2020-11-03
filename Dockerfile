FROM golang:latest
RUN mkdir /bins
RUN apt-get update && apt-get --assume-yes install zip jq autoconf libtool lib32z1-dev
RUN git clone --recursive https://github.com/grpc/grpc
RUN cd grpc && make grpc_python_plugin && ls bins/opt
RUN mv /go/grpc/bins/opt/grpc_python_plugin /bins/protoc-gen-grpc_python
RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-openapiv2
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protoc-3.13.0-linux-x86_64.zip
RUN unzip protoc-*.zip
RUN curl -o /bins/swagger $(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | \
  jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
RUN chmod +x /bins/swagger
RUN mv /go/bin/* /bins

FROM alpine:latest
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
RUN apk add glibc-2.32-r0.apk bash libstdc++
ENV LD_LIBRARY_PATH="/lib:/usr/lib/"
COPY . /app
COPY --from=0 /bins /bin
COPY --from=0 /go/include /include
COPY --from=0 /go/src/github.com/grpc-ecosystem /

