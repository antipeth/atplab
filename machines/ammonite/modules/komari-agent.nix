{config, ...}: let
  cfg = config.services.komari-agent;
in {
  sops.secrets.ammonite-komari-agent-config = {
    mode = "0400";
    owner = cfg.user;
    group = cfg.user;
    format = "binary";
    sopsFile = ../secrets/komari-agent-config;
  };
  services.komari-agent = {
    enable = true;
    configPath = config.sops.secrets.ammonite-komari-agent-config.path;
  };
}
