_: {
  services.komari-agent-rs = {
    enable = true;
    token = import ../values/komari-token.nix;
    endpoint = import ../values/komari-endpoint.nix;
    extraFlags = "-f 10";
  };
}
