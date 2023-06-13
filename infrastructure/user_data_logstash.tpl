#!/bin/bash

# Update all packages
apt-get update
apt-get install curl -y
sysctl -w vm.max_map_count=262144
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker run -d -p 5001:5001 --restart unless-stopped --name logstash-allianz -e OS_USER='${OS_USER}' -e OS_PASSWD='${OS_USER}' -e OS_URL='${OS_USER}' guillegregoret/allianz-logstash:latest
#docker run -d -p 5001:5001 --restart unless-stopped --name logstash-allianz -e OS_USER='allianz-os' -e OS_PASSWD='3EF92b15150894018E05-747d4CFAAeB0' -e OS_URL='https://search-opensearch-allianz-dcycxe2wxpoabv6x4iyo5mj2jm.us-east-1.es.amazonaws.com:443' guillegregoret/allianz-logstash:latest