{config, ...}: let
  cfg = config.services.tailscale;
in {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraSetFlags = ["--accept-dns=false"];
  };
  networking.firewall.trustedInterfaces = [cfg.interfaceName];
}
