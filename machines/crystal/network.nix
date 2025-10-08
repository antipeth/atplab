_: {
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = import ../../sops/eval/crystal/ipv4-address1.nix;
        prefixLength = import ../../sops/eval/crystal/ipv4-prefix.nix;
      }
    ];
    defaultGateway = {
      address = import ../../sops/eval/crystal/ipv4-gateway.nix;
      interface = "eth0";
    };
    # interfaces.eth0.ipv6.addresses = [
    #   {
    #     address = import ../../sops/eval/crystal/ipv6-address1.nix;
    #     prefixLength = import ../../sops/eval/crystal/ipv6-prefix.nix;
    #   }
    #   {
    #     address = import ../../sops/eval/crystal/ipv6-address2.nix;
    #     prefixLength = import ../../sops/eval/crystal/ipv6-prefix.nix;
    #   }
    #   {
    #     address = import ../../sops/eval/crystal/ipv6-address3.nix;
    #     prefixLength = import ../../sops/eval/crystal/ipv6-prefix.nix;
    #   }
    # ];
    # defaultGateway6 = {
    #   address = import ../../sops/eval/crystal/ipv6-gateway.nix;
    #   interface = "eth0";
    # };
  };
}
