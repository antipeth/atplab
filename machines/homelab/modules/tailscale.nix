{config, ...}: let
  cfg = config.services.tailscale;
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
    extraSetFlags = ["--accept-dns=false"];
  };
  networking.firewall.trustedInterfaces = [cfg.interfaceName];
}
