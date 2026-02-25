_: {
  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddresses = "172.20.192.2:18000";
      allowedIPs = ["172.20.192.3"];
    };
  };
  networking.firewall.allowedTCPPorts = [18000];
}
