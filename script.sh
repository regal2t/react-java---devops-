#!/bin/bash

# Create directories if they do not exist
mkdir -p prometheus
mkdir -p grafana/provisioning/datasources
mkdir -p promtail
mkdir -p loki

# Create Prometheus configuration file
cat << EOF > prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

remote_write:
  - url: 'http://loki:3100/loki/api/v1/push'
EOF

# Create Grafana data source configuration
cat << EOF > grafana/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF

# Create Promtail configuration file
cat << EOF > promtail/promtail-local-config.yaml
server:
  http_listen_port: 9080
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push
    external_labels:
      job: promtail
      __path__: /var/log/container_logs/*.log
scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
EOF

# Create Loki configuration file
cat << EOF > loki/local-config.yaml
auth_enabled: false
server:
  http_listen_port: 3100
  grpc_listen_port: 9095
ingester:
  lifecycler:
    address: loki:3101
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
chunk_store_config:
  max_look_back_period: 0s
table_manager:
  retention_deletes_enabled: false
  retention_period: 0s
EOF

echo "File structure and configuration files created successfully."
