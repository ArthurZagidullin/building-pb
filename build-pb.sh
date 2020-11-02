#!/bin/bash

function walk() {
  echo "Start walking $1"
  for f in "$1"/*
  do
    echo "Directory or File Processing $f"
    if [ -d "$f" ]; then
      echo "Is a Directory go walk $f"
      walk "$f"
    else
      if [ "${f: -6}" == ".proto" ]; then
        echo "Is a Proto File go compile $f"
        protoc -I/include -I/app/protobuf -I/grpc-gateway/third_party/googleapis \
          -I/grpc-gateway --python_out=/artifacts --grpc_python_out=/artifacts \
          --grpc-gateway_out /artifacts --grpc-gateway_opt logtostderr=true --grpc-gateway_opt paths=source_relative \
          --openapiv2_out /artifacts/swagger --openapiv2_opt logtostderr=true --go_out=plugins=grpc:/artifacts
      fi
    fi
  done
}

mkdir -p /artifacts/swagger
walk /app/protobuf