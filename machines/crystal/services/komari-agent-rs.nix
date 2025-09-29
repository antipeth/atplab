_: {
  services.komari-agent-rs = {
    enable = true;
    token = import ../../../sops/eval/crystal/komari-token.nix;
    endpoint = "http://127.0.0.1:25774";
    extraFlags = "-f 10";
  };
}
