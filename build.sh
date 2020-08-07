#!/bin/bash

set -ue

master_key=${MASTER_KEY_PATH? "Set environment variable MASTER_KEY_PATH"};
input=${1? "Param missing for Docker Image Tag"};

git clone https://github.com/tattva-network/vpn.tattva.network.git rails_app
cp ${master_key} rails_app/config/
docker build -t ${1} .
rm -rf ./rails_app
