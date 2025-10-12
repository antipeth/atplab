_: {
  services.komari-agent-rs = {
    enable = true;
    token = import ../values/komari-token.nix;
    endpoint = "http://127.0.0.1:25774";
  };
}
