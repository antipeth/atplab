_: {
  services.komari-agent-rs = {
    enable = true;
    token = import ../values/komari-token.nix;
    endpoint = "https://eye.0pt.dpdns.org";
  };
}
