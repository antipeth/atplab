_: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraSetFlags = ["--accept-dns=false"];
  };
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
