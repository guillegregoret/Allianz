#!/bin/bash

# Update all packages
apt-get update
apt-get install curl -y
sysctl -w vm.max_map_count=262144
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker run -d -p 5001:5001 --restart unless-stopped --name logstash-allianz -e USER='allianz-os' -e PASSWD='3EF92b15150894018E05-747d4CFAAeB0' -e HOST='https://search-allianz-opensearch-gh5nnr6krjj4gxxsfdrziury4i.us-east-1.es.amazonaws.com:443' guillegregoret/allianz-logstash:latest