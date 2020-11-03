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
        protoc -I/include -I${APP_DIR}/protobuf -I/grpc-gateway/third_party/googleapis -I/grpc-gateway \
          --go_out=plugins=grpc:/artifacts/golang \
          --grpc-gateway_out /artifacts/golang --grpc-gateway_opt logtostderr=true \
          --python_out=/artifacts/python --grpc_python_out=/artifacts/python \
           --openapiv2_out /artifacts/swagger --openapiv2_opt logtostderr=true \
          "$f"
      fi
    fi
  done
}

# Adds empty __init__.py file to every subfolder. Needed to make python
# package from generated code.
function add_init() {
  for f in "$1"/*
  do
    if [ -d "$f" ]; then
      echo "Is a direcory. Add __init__.py and go deeper inside $f"
      touch "${f}/__init__.py"
      add_init "$f"
    fi
  done
}

mkdir -p /artifacts/{swagger,python,golang}
walk "${APP_DIR}"/protobuf
add_init /artifacts/python