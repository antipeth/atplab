_: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
    extraSetFlags = ["--accept-dns=false"];
  };
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
