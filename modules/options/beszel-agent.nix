{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.beszel-agent;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.beszel-agent = {
    enable = mkEnableOption "beszel-agent";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the default port in the firewall";
    };
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The address for beszel-agent to listen";
    };
    port = mkOption {
      type = types.str;
      default = "25774";
      description = "The port for beszel-agent to listen";
    };
    key = mkOption {
      type = types.str;
      default = null;
      description = "The beszel-agent use public key(s) for SSH authentication";
    };
    extraFlags = mkOption {
      type = types.str;
      default = "";
      description = "Extra commandline options for beszel-agent";
    };
    user = mkOption {
      type = types.str;
      default = "beszel-agent";
      description = "The user beszel-agent should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "beszel-agent";
      description = "The group beszel-agent should run as.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.beszel-agent = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "beszel-agent";
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.beszel-agent}/bin/beszel-agent -l "${cfg.host}:${cfg.port}" \
          -k "${cfg.key}" \
          ${cfg.extraFlags}
        '';
        ExecStop = "on-failure";
        StateDirectory = "beszel-agent";
        SyslogIdentifier = "beszel-agent";
        RuntimeDirectory = "beszel-agent";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall ["${cfg.port}"];

    users.users = mkIf (cfg.user == "beszel-agent") {
      beszel-agent = {
        name = "beszel-agent";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "beszel-agent") {beszel-agent = {};};
  };
}
