_: {
  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = import ../values/prometheus-node-address.nix;
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
}
