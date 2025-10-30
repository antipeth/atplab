{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.beszel-hub;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.beszel-hub = {
    enable = mkEnableOption "beszel-hub";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the default port in the firewall";
    };
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The address for beszel-hub to listen";
    };
    port = mkOption {
      type = types.str;
      default = "25774";
      description = "The port for beszel-hub to listen";
    };
    user = mkOption {
      type = types.str;
      default = "beszel-hub";
      description = "The user beszel-hub should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "beszel-hub";
      description = "The group beszel-hub should run as.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.beszel-hub = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "beszel-hub";
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.beszel}/bin/beszel-hub serve --http ${cfg.host}:${cfg.port}";
        ExecStop = "on-failure";
        StateDirectory = "beszel-hub";
        SyslogIdentifier = "beszel-hub";
        RuntimeDirectory = "beszel-hub";
        WorkingDirectory = "/var/lib/beszel-hub";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall ["${cfg.port}"];

    users.users = mkIf (cfg.user == "beszel-hub") {
      beszel-hub = {
        name = "beszel-hub";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "beszel-hub") {beszel-hub = {};};
  };
}
