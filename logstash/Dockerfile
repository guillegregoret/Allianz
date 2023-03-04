FROM opensearchproject/logstash-oss-with-opensearch-output-plugin:7.13.4
EXPOSE 5001
CMD logstash -e ' \
input { \
    tcp {\
        port => 5001\
    }\
}\
output {\
     opensearch {\
         hosts       => "https://search-opensearch-allianz-i3ltsi2lksxuxdcgsxiguummdm.us-east-1.es.amazonaws.com:443" \
         user        => "allianz-os" \
         password    => "3EF92b15150894018E05-747d4CFAAeB0" \
         index       => "logstash-logs-%%{+YYYY.MM.dd}"\
         ecs_compatibility => disabled\
         ssl_certificate_verification => false\
     }\
}'\
