#!/bin/bash

# Update all packages
apt-get update
apt-get install curl -y
sysctl -w vm.max_map_count=262144
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker run -d -p 5001:5001 --restart unless-stopped --name logstash-allianz -e OS_USER='${OS_USER}' -e OS_PASSWD='${OS_PASSWD}' -e OS_URL='${OS_URL}' guillegregoret/allianz-logstash:latest
