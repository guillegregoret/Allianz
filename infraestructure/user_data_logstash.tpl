#!/bin/bash

# Update all packages
apt-get update
apt-get install curl -y
sysctl -w vm.max_map_count=262144
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker run -it -p 5001:5001 --restart unless-stopped --name logstash opensearchproject/logstash-oss-with-opensearch-output-plugin:7.13.4 -e '
input \{
    tcp \{
        port => 5001
        codec => json
        \{
            charset => "UTF-8"
        \}
    \}
\}
output /{
     opensearch /{
         hosts       => "https://search-allianz-opensearch-gh5nnr6krjj4gxxsfdrziury4i.us-east-1.es.amazonaws.com:443"
         user        => "allianz-os"
         password    => "3EF92b15150894018E05-747d4CFAAeB0"
         index       => "logstash-logs-%\{+YYYY.MM.dd\}"
         ecs_compatibility => disabled
         ssl_certificate_verification => false
     \}
\}'