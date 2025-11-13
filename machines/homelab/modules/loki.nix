{config, ...}: let
  cfg = config.services.loki;
in {
  services = {
    loki = {
      enable = true;
      configuration = {
        server.http_listen_port = 3100;
        auth_enabled = false;
        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore = {
                store = "inmemory";
              };
              replication_factor = 1;
            };
          };
          wal = {
            enabled = true;
            dir = "/var/lib/loki/wal";
            checkpoint_duration = "5m";
          };
          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 999999;
          chunk_retain_period = "30s";
        };
        schema_config = {
          configs = [
            {
              from = "2025-10-11";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };
        storage_config = {
          tsdb_shipper = {
            active_index_directory = "/var/lib/loki/tsdb-active";
            cache_location = "/var/lib/loki/tsdb-cache";
            cache_ttl = "24h";
            resync_interval = "5m";
          };
          filesystem.directory = "/var/lib/loki/chunks";
        };
        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
          tsdb_max_query_parallelism = 128;
          tsdb_sharding_strategy = "power_of_two";
        };
        compactor = {
          working_directory = "/var/lib/loki";
          compactor_ring = {
            kvstore = {
              store = "inmemory";
            };
          };
          retention_enabled = true;
          retention_delete_delay = "2h";
          retention_delete_worker_count = 50;
          compaction_interval = "10m";
          delete_request_store = "filesystem";
        };
      };
    };
    promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [
          {
            url = "http://127.0.0.1:${config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
          }
        ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = "${config.networking.hostName}";
              };
            };
            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
  };
}
