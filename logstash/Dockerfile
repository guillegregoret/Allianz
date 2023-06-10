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
         hosts       => "${OS_URL}" \
         user        => "${OS_USER}" \
         password    => "${OS_PASSWD}" \
         index       => "logstash-logs-%%{+YYYY.MM.dd}"\
         ecs_compatibility => disabled\
         ssl_certificate_verification => true\
     }\
}'\