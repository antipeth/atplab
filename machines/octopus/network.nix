{lib, ...}: {
  networking = {
    useDHCP = lib.mkForce false;
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = import ../../sops/eval/octopus/ipv4-address1.nix;
          prefixLength = import ../../sops/eval/octopus/ipv4-prefix.nix;
        }
      ];
      ipv6.addresses = [
        {
          address = import ../../sops/eval/octopus/ipv6-address1.nix;
          prefixLength = import ../../sops/eval/octopus/ipv6-prefix.nix;
        }
      ];
    };
    defaultGateway = {
      address = import ../../sops/eval/octopus/ipv4-gateway.nix;
      interface = "eth0";
    };
    defaultGateway6 = {
      address = import ../../sops/eval/octopus/ipv6-gateway.nix;
      interface = "eth0";
    };
  };
}
