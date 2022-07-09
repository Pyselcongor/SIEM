#!/bin/bash

# VARS

STACK_VERSION=8.1.2
CLUSTER_NAME=elastic-cluster
ELASTIC_PASSWORD=ChangeMe$
KIBANA_PASSWORD=ChangeMe$

STACK_IP=192.168.0.125
ES_PORT=9200
LOGSTASH_PORT=5140
KIBANA_PORT=5601
ELASTICSEARCH_HOSTNAME=es-01
KIBANA_HOSTNAME=192.168.0.125
LOGSTASH_HOSTNAME=192.168.0.125

# Increase or decrease based on the available host memory (in bytes)
MEM_LIMIT=8589934592

COMPOSE_PROJECT_NAME=elastic-stack
COMPOSE_ROOT="/docker/elastic-stack/"
ELASTICSEARCH_ROOT=$COMPOSE_ROOT/elasticsearch
KIBANA_ROOT=$COMPOSE_ROOT/kibana
LOGSTASH_ROOT=$COMPOSE_ROOT/logstash

mkdir -p $COMPOSE_ROOT
mkdir $ELASTICSEARCH_ROOT $KIBANA_ROOT $LOGSTASH_ROOT $COMPOSE_ROOT/scripts
mkdir $LOGSTASH_ROOT/certs $LOGSTASH_ROOT/conf.d


# CREATING CONFIG FILES

#.env
echo \
"ELASTIC_PASSWORD=$ELASTIC_PASSWORD\n"\
"\n"\
"KIBANA_PASSWORD=$KIBANA_PASSWORD\n"\
"\n"\
"# Version of Elastic products\n"\
"STACK_VERSION=$STACK_VERSION\n"\
"\n"\
"# Set the cluster name\n"\
"CLUSTER_NAME=$CLUSTER_NAME\n"\
"\n"\
"ES_PORT=$ES_PORT\n"\
"\n"\
"LOGSTASH_PORT=$LOGSTASH_PORT\n"\
"\n"\
"KIBANA_PORT=$KIBANA_PORT\n"\
"\n"\
"MEM_LIMIT=$MEM_LIMIT\n"\
"\n"\
"COMPOSE_PROJECT_NAME=$COMPOSE_PROJECT_NAME\n"\
> $COMPOSE_ROOT/.env

#elasticsearch.yml
echo \
"cluster.name: elastic-stack\n"\
"node.name: es-01\n"\
"node.roles: [ master, data_hot, data_content, ingest, ml, remote_cluster_client, transform ]\n"\
"\n"\
"path.data: /usr/share/elasticsearch/data\n"\
"path.logs: /var/log/elasticsearch\n"\
"\n"\
"transport.port: 9300\n"\
"network.host: 0.0.0.0\n"\
"http.port: $ES_PORT\n"\
"\n"\
"cluster.initial_master_nodes: es-01\n"\
"\n"\
"xpack.security.enabled: true\n"\
"xpack.security.transport.ssl:\n"\
"       enabled: true\n"\
"       key: certs/es-01/es-01.key\n"\
"       certificate: certs/es-01/es-01.crt\n"\
"       certificate_authorities: certs/ca/ca.crt\n"\
"       verification_mode: certificate\n"\
"xpack.security.http.ssl:\n"\
"       enabled: true\n"\
"       key: certs/es-01/es-01.key\n"\
"       certificate: certs/es-01/es-01.crt\n"\
> $ELASTICSEARCH_ROOT/es-01.yml

#kibana.yml
echo \
"server.port: $KIBANA_PORT\n"\
"monitoring.kibana.collection.enabled: false\n"\
"server.host: 0.0.0.0\n"\
"elasticsearch.hosts: ["https://$ELASTICSEARCH_HOSTNAME:9200"]\n"\
"elasticsearch.username: "kibana_system"\n"\
"elasticsearch.password: "$KIBANA_PASSWORD"\n"\
"\n"\
"elasticsearch.ssl.certificateAuthorities: [ "config/certs/ca/ca.crt" ]\n"\
"elasticsearch.ssl.verificationMode: "none"\n"\
"\n"\
"server.ssl.enabled: true\n"\
"server.ssl.certificate: config/certs/kibana/kibana.crt\n"\
"server.ssl.key: config/certs/kibana/kibana.key\n"\
"server.ssl.certificateAuthorities: config/certs/ca/ca.crt \n"\
"\n"\
"server.publicBaseUrl: "https://$KIBANA_HOSTNAME:5601"\n"\
"\n"\
"xpack.encryptedSavedObjects.encryptionKey: "uLzNx5Ypbr7inCHRoxQ9sddqkoregqs321!\n"\
> $KIBANA_ROOT/kibana.yml

#logstash.yml
echo \
"path.data: /usr/share/logstash/data\n"\
"pipeline.unsafe_shutdown: true\n"\
"config.reload.automatic: true\n"\
"config.reload.interval: 30s\n"\
"path.logs: /usr/share/log/logstash/logs\n"\
> $LOGSTASH_ROOT/logstash.yml


