{
  config,
  pkgs,
  ...
}: {
  # Wireguard Peer
  sops.secrets.cthulhu-dn42-wg-privatekey = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/dn42-wg-private;
  };
  networking.wg-quick.interfaces = {
    dn42-atp = {
      listenPort = 20003;
      table = "off";
      address = [
        "fe80::9334/64"
        "172.20.192.3/28"
        "fd25:5547:5a89::3/48"
      ];
      peers = [
        {
          publicKey = "L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=";
          allowedIPs = [
            "172.20.192.1"
            "fd25:5547:5a89::1"
            "fe80::67b3/64"
          ];
          endpoint = import ../values/dn42-peer-atp-octopus.nix;
        }
        {
          publicKey = "1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=";
          allowedIPs = [
            "172.20.192.2"
            "fd25:5547:5a89::2"
            "fe80::b72b/64"
          ];
          endpoint = import ../values/dn42-peer-atp-squid.nix;
        }
      ];
      # publicKey: rE4mEBQo2Z/kLkg7a89bSLN76asevkqA7GygPJfv5D8=
      privateKeyFile = config.sops.secrets.cthulhu-dn42-wg-privatekey.path;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      20003
      # BGP
      179
    ];
    allowedUDPPorts = [20003];
  };
}
