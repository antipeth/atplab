{
  lib,
  pkgs,
  ...
}:
lib.mkIf true {
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
    config = {lib, ...}: {
      services.glances = {
        port = 19999;
        enable = true;
        openFirewall = true;
      };
      system.stateVersion = "25.11";

      networking = {
        # firewall = {
        #   enable = true;
        #   allowedTCPPorts = [19999];
        # };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
