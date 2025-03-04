{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      port = 5432;
      max_connections = 20;
      shared_buffers = "256MB";
      effective_cache_size = "768MB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = "0.9";
      wal_buffers = "7864kB";
      default_statistics_target = 100;
      random_page_cost = "1.1";
      effective_io_concurrency = 200;
      work_mem = "3276kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
  };
}
