_: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
  };
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
