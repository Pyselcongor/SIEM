#!/bin/bash

cp /var/lib/docker/volumes/elastic-stack_certs/_data/logstash/* /docker/elastic-stack/logstash/certs/
cp /var/lib/docker/volumes/elastic-stack_certs/_data/ca/ca.crt /docker/elastic-stack/logstash/certs/

openssl pkcs8 -inform PEM -in /docker/elastic-stack/logstash/certs/logstash.key -topk8 -nocrypt -outform PEM -out /docker/elastic-stack/logstash/certs/logstash.pkcs8.key
chmod 644 /docker/elastic-stack/logstash/certs/logstash.pkcs8.key
