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
    # publicKey: rE4mEBQo2Z/kLkg7a89bSLN76asevkqA7GygPJfv5D8=
    privateKeyFile = config.sops.secrets."${hostname}-dn42-wg-privatekey".path;
    # Your DN42 info
    asn = 4242420003;
    ownIP = "172.20.192.3";
    ownIPv6 = "fd25:5547:5a89::3";
    ownNet = "172.20.192.0/28";
    ownNetv6 = "fd25:5547:5a89::/48";
    peers = {
      # Key becomes the peer name used in interface/BGP session names
      atp1 = {
        wg = {
          listenPort = 40000;
          publicKey = "L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=";
          endpoint = import ../values/dn42-peer-atp-octopus.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.20.192.1";
          remoteV6 = "fd25:5547:5a89::1";
        };
        bgp = {
          remoteAs = 4242420003;
          neighborLinkLocal = "fe80::67b3";
        };
      };
      atp2 = {
        wg = {
          listenPort = 40001;
          publicKey = "1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=";
          endpoint = import ../values/dn42-peer-atp-squid.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.20.192.2";
          remoteV6 = "fd25:5547:5a89::2";
        };
        bgp = {
          remoteAs = 4242420003;
          neighborLinkLocal = "fe80::b72b"; # Comment this to use dn42 ipv6 address for bgp (optionally)
        };
      };
      as20728 = {
        wg = {
          listenPort = 20728;
          publicKey = "rxVEiqcS4UseSPlLyHI716WRKOWgKp3QtTWXs/2FdGw=";
          endpoint = import ../values/dn42-peer-as20728.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.22.106.29";
          remoteV6 = "fd38:8b09:eb92::29";
        };
        bgp = {
          remoteAs = 4242420728;
          neighborLinkLocal = "fe80::0728";
        };
      };
      as21984 = {
        wg = {
          listenPort = 21984;
          publicKey = "Nt69jupNZY1M9QloP3+qu37OVO5Ua6zNynF4HTmygkQ=";
          endpoint = import ../values/dn42-peer-as21984.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.21.118.129";
          remoteV6 = "fdee:6aaa:1d9::1";
        };
        bgp = {
          remoteAs = 4242421984;
          neighborLinkLocal = "fe80::cd2a";
        };
      };
      # Automatic Peering: https://dn42.routedbits.io
      as20207 = {
        wg = {
          listenPort = 20207;
          publicKey = "FIk95vqIJxf2ZH750lsV1EybfeC9+V8Bnhn8YWPy/l8=";
          endpoint = import ../values/dn42-peer-as20207.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.20.19.71";
          remoteV6 = "fdb1:e72a:343d::8";
        };
        bgp = {
          remoteAs = 4242420207;
        };
      };
      # Automatic Peering: https://blog.moe233.net/dn42/
      as20253 = {
        wg = {
          listenPort = 20253;
          publicKey = "vRRfNnGL7jpKGBJjLZg612vHQulDOtICkgXCC++1+2g=";
          endpoint = "ams.dn42.moe233.net:20003";
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.23.69.162";
          remoteV6 = "fd05:4b:cce::2";
        };
        bgp = {
          remoteAs = 4242420253;
          enableV4 = false;
          enableMpBGP = true;
          neighborLinkLocal = "fe80::253";
        };
      };
      # Automatic Peering: https://hcartiaux.github.io/dn42/
      as20263 = {
        wg = {
          listenPort = 20263;
          publicKey = "d7ICCZTiZaYlf9ueUuPlVV1QdLWLobIlCiI9fxet+H4=";
          endpoint = "de-fra1.flap42.eu:52030";
          linkLocal = "fe80::9334/64";
        };
        bgp = {
          remoteAs = 4242420263;
          enableV4 = false;
          enableMpBGP = true;
          neighborLinkLocal = "fe80::263";
        };
      };
      # Automatic Peering: https://peer-dn42.nedifinita.com/
      as20454 = {
        wg = {
          listenPort = 20454;
          publicKey = "pCTgngczpFgIDbZzfxtz6tiaiFo59b2GbeJEEc21mA0=";
          endpoint = import ../values/dn42-peer-as20454.nix;
          linkLocal = "fe80::9334/64";
          remoteV4 = "172.22.159.102";
          remoteV6 = "fdef:fa9b:62b:f102::1";
        };
        bgp = {
          remoteAs = 4242420454;
          neighborLinkLocal = "fe80::454:102";
        };
      };
      # Automatic Peering: https://www.chrismoos.com/dn42-peering/
      as21588 = {
        wg = {
          listenPort = 21588;
          publicKey = "MD1EdVe9a0yycUdXCH3A61s3HhlDn17m5d07e4H33S0=";
          endpoint = import ../values/dn42-peer-as21588.nix;
          remoteV4 = "172.20.16.141";
        };
        bgp = {
          remoteAs = 4242421588;
          enableV6 = false;
        };
      };
    };
  };
}
