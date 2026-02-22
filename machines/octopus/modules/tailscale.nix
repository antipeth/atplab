{config, ...}: let
  cfg = config.services.tailscale;
in {
  services.tailscale = {
    enable = false;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraSetFlags = ["--accept-dns=false"];
  };
  networking.firewall.trustedInterfaces = [cfg.interfaceName];
}
