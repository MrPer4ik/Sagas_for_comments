#!/bin/bash

PATH=$PATH:/home/alexander/.mix/escripts/
protoc --elixir_out=plugins=grpc:./ ./lib/saga/*.proto