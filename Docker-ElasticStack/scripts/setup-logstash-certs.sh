#!/bin/bash

cp /var/lib/docker/volumes/elastic_certs/_data/logstash/* /home/pysel/docker/logstash/certs/
cp /var/lib/docker/volumes/elastic_certs/_data/ca/ca.crt /home/pysel/docker/logstash/certs/

openssl pkcs8 -inform PEM -in /home/pysel/docker/logstash/certs/logstash.key -topk8 -nocrypt -outform PEM -out /home/pysel/docker/logstash/certs/logstash.pkcs8.key
chmod 644 /home/pysel/docker/logstash/certs/logstash.pkcs8.key

