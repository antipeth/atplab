{
  config,
  pkgs,
  ...
}: {
  # Wireguard Peer
  sops.secrets.squid-dn42-wg-privatekey = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/dn42-wg-private;
  };
  networking.wg-quick.interfaces = {
    dn42-atp = {
      listenPort = 20003;
      address = [
        "fe80::b72b/64"
        "172.20.192.2/28"
        "fd25:5547:5a89::2/48"
      ];
      postUp = ''
        ${pkgs.iproute2}/bin/ip addr add fe80::b72b/64 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add fd25:5547:5a89::2/128 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add 172.20.192.2/32 peer 172.20.192.1/32 dev dn42-atp
      '';
      peers = [
        {
          publicKey = "L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=";
          allowedIPs = [
            "10.0.0.0/8"
            "172.20.0.0/14"
            "172.31.0.0/16"
            "fd00::/8"
            "fe80::/64"
          ];
          endpoint = import ../values/dn42-peer-atp-octopus.nix;
        }
      ];
      # publicKey: 1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=
      privateKeyFile = config.sops.secrets.squid-dn42-wg-privatekey.path;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [20003];
    allowedUDPPorts = [20003];
  };
}
