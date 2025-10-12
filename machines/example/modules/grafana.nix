_: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "monitor.example.com";
        # root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
        # serve_from_sub_path = true;
        # protocol = "https";
      };
    };
    # declarativePlugins = with pkgs.grafanaPlugins; [ netdatacloud-netdata-datasource ];
  };
}
