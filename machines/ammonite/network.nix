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
    };
    defaultGateway = {
      address = import values/ipv4-gateway.nix;
      interface = "eth0";
    };
  };
}
