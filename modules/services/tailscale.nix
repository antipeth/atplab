{config, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
