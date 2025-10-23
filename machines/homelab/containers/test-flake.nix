{lib, ...}:
lib.mkIf false {
  networking.nat = {
    enable = true;
    # Use "ve-*" when using nftables instead of iptables
    internalInterfaces = ["ve-*"];
    externalInterface = "eth0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };
  containers.test = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.2";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    flake = "../../../#container";
    # config = {lib, ...}: {
    #   services.glances = {
    #     port = 19999;
    #     enable = true;
    #     openFirewall = true;
    #   };
    # };
  };
}
