{
  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = [
      "eth0"
      "vm-1"
    ];
    networkConfig = {
      Bridge = "br0";
    };
  };

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = [
        "192.168.6.130/24"
      ];
      Gateway = "192.168.6.1";
      DNS = [
        "127.0.0.1"
        "::1"
      ];
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };
}
