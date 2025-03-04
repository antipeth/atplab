{
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = import ../../sops/eval/auction/ipv4-address1.nix;
        prefixLength = import ../../sops/eval/auction/ipv4-prefix.nix;
      }
    ];
    defaultGateway = {
      address = import ../../sops/eval/auction/ipv4-gateway.nix;
      interface = "eth0";
    };
    interfaces.eth0.ipv6.addresses = [
      {
        address = import ../../sops/eval/auction/ipv6-address1.nix;
        prefixLength = import ../../sops/eval/auction/ipv6-prefix.nix;
      }
    ];
    defaultGateway6 = {
      address = import ../../sops/eval/auction/ipv6-gateway.nix;
      interface = "eth0";
    };
  };
}
