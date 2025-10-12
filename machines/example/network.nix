{lib, ...}: {
  # This is for vps
  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = lib.mkForce false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = "10.10.10.10";
        prefixLength = "24";
      }
    ];
    defaultGateway = {
      address = "10.10.10.1";
      interface = "eth0";
    };
    interfaces.eth0.ipv6.addresses = [
      {
        address = "83C1:D487:6A06::4DF0";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "83C1:D487:6A06::1";
      interface = "eth0";
    };
  };
}
