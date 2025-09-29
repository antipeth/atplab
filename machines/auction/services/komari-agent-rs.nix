_: {
  services.komari-agent-rs = {
    enable = true;
    token = import ../../../sops/eval/auction/komari-token.nix;
    endpoint = "https://eye.0pt.dpdns.org";
    extraFlags = "-f 10";
  };
}
