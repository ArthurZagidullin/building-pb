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
        protoc -I/usr/local/include -Iprotobuf \
        -I"$GOPATH"/src -I"$f" \
        --go_out=plugins=grpc:/artifacts \
        "$f"
      fi
    fi
  done
}

walk protobuf