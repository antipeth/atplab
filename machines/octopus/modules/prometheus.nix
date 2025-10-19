{config, ...}: let
  cfg = config.services.prometheus;
in {
  services = {
    prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "${toString cfg.exporters.node.listenAddress}:${toString cfg.exporters.node.port}"
                (import ../values/prometheus-target1.nix)
              ];
            }
          ];
        }
      ];
      exporters = {
        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 9000;
          enabledCollectors = [
            "systemd"
            "processes"
          ];
          extraFlags = [
            "--collector.ethtool"
            "--collector.softirqs"
            "--collector.tcpstat"
          ];
        };
      };
    };
  };
}
