#!/bin/bash

# Update all packages
apt-get update
apt-get install curl -y
hostnamectl set-hostname consul_cluster
echo "Changing Hostname"
hostname "consul_cluster"
echo "consul_cluster" > /etc/hostname
sysctl -w vm.max_map_count=262144
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

docker network create -d bridge backend
docker run -d --restart unless-stopped --name=consul --network="backend" --hostname=consul -p 8500:8500 -p 8600:8600 consul:1.12.2 consul agent -server -client 0.0.0.0 -ui -bootstrap-expect=3 -data-dir=/consul/data -retry-join=consul2 -retry-join=consul3 -datacenter=blr
docker run -d --restart unless-stopped --name=consul2 --network="backend" --hostname=consul2 --expose=8500 --expose=8600 consul:1.12.2 consul agent -server -data-dir=/consul/data -retry-join=consul -retry-join=consul3 -datacenter=blr
docker run -d --restart unless-stopped --name=consul3 --network="backend" --hostname=consul3 --expose=8500 --expose=8600 consul:1.12.2 consul agent -server -data-dir=/consul/data -retry-join=consul -retry-join=consul2 -datacenter=blr