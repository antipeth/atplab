{lib, ...}: {
  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = lib.mkForce false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = import values/ipv4-address1.nix;
        prefixLength = import values/ipv4-prefix.nix;
      }
    ];
    defaultGateway = {
      address = import values/ipv4-gateway.nix;
      interface = "eth0";
    };
    interfaces.eth0.ipv6.addresses = [
      {
        address = import values/ipv6-address1.nix;
        prefixLength = import values/ipv6-prefix.nix;
      }
    ];
    defaultGateway6 = {
      address = import values/ipv6-gateway.nix;
      interface = "eth0";
    };
  };
}
