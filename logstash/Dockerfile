FROM opensearchproject/logstash-oss-with-opensearch-output-plugin:7.13.4
EXPOSE 5001
CMD logstash -e ' \
input { \
    tcp {\
        port => 5001\
        codec => json\
        {\
            charset => "UTF-8"\
        }\
    }\
}\
output {\
     opensearch {\
         hosts       => "${HOST}"\
         user        => "${USER}"\
         password    => "${PASSWD}"\
         index       => "logstash-logs-%%{+YYYY.MM.dd}"\
         ecs_compatibility => disabled\
         ssl_certificate_verification => false\
     }\
}'\
