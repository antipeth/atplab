{lib, ...}: {
  networking = {
    useDHCP = lib.mkForce false;
    interfaces = {
      eth0.ipv4.addresses = [
        {
          address = import values/ipv4-address1.nix;
          prefixLength = import values/ipv4-prefix.nix;
        }
      ];
      he-ipv6.ipv6.addresses = [
        {
          address = import values/he-ipv6-address1.nix;
          prefixLength = import values/he-ipv6-prefix.nix;
        }
      ];
    };
    defaultGateway = {
      address = import values/ipv4-gateway.nix;
      interface = "eth0";
    };
    defaultGateway6 = {
      address = import values/he-ipv6-gateway.nix;
      interface = "he-ipv6";
    };
    sits.he-ipv6 = {
      dev = "eth0";
      local = import values/ipv4-address1.nix;
      remote = import values/he-ipv6-sit-remote.nix;
      ttl = 255;
    };
  };
}
