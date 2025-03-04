{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [ "localhost:9090" ];
          }
        ];
      }
      {
        job_name = "netdata";
        metrics_path = "/api/v1/allmetrics";
        params = {
          format = [ "prometheus" ];
        };
        static_configs = [
          {
            targets = [ "localhost:19999" ];
          }
        ];
      }
    ];
  };
  # networking.firewall = {
  #   allowedTCPPorts = [ 9090 ];
  #   allowedUDPPorts = [ 9090 ];
  # };
}
