{
  config,
  hostname,
  ...
}: {
  # Wireguard Peer
  sops.secrets."${hostname}-dn42-wg-privatekey" = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/dn42-wg-private;
  };
  services.dn42 = {
    enable = true;
    # publicKey: 1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=
    privateKeyFile = config.sops.secrets."${hostname}-dn42-wg-privatekey".path;
    # Your DN42 info
    asn = 4242420003;
    ownIP = "172.20.192.2";
    ownIPv6 = "fd25:5547:5a89::2";
    ownNet = "172.20.192.0/28";
    ownNetv6 = "fd25:5547:5a89::/48";
    peers = {
      # Key becomes the peer name used in interface/BGP session names
      atp_1 = {
        wg = {
          listenPort = 40000;
          publicKey = "L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=";
          endpoint = import ../values/dn42-peer-atp-octopus.nix;
          linkLocal = "fe80::b72b/64";
          remoteV4 = "172.20.192.1";
          remoteV6 = "fd25:5547:5a89::1";
        };
        bgp = {
          remoteAs = 4242420003;
          neighborLinkLocal = "fe80::67b3";
        };
      };
      atp_3 = {
        wg = {
          listenPort = 40001;
          publicKey = "rE4mEBQo2Z/kLkg7a89bSLN76asevkqA7GygPJfv5D8=";
          endpoint = import ../values/dn42-peer-atp-cthulhu.nix;
          linkLocal = "fe80::67b3/64";
          remoteV4 = "172.20.192.3";
          remoteV6 = "fd25:5547:5a89::3";
        };
        bgp = {
          remoteAs = 4242420003;
          neighborLinkLocal = "fe80::9334";
        };
      };
    };
  };
}
