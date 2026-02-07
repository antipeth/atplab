{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.vigil-agent;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.vigil-agent = {
    enable = mkEnableOption "vigil-agent";
    server = mkOption {
      type = types.str;
      default = "http://localhost:9080";
      description = "Vigil server URL.";
    };
    interval = mkOption {
      type = types.int;
      default = 60;
      description = ''
        Reporting interval in seconds.
        Set to 0 to run once and exit.
      '';
    };
    hostname = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override hostname reported to the Vigil server.";
    };
    extraFlags = mkOption {
      type = types.str;
      default = "";
      description = "Extra command line options passed to vigil-agent.";
    };
    user = mkOption {
      type = types.str;
      default = "vigil-agent";
      description = "The user vigil-agent should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "vigil-agent";
      description = "The group vigil-agent should run as.";
    };
  };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_final: prev: {
        vigil-agent = prev.callPackage ../../pkgs/vigil-agent/default.nix {};
      })
    ];
    systemd.services.vigil-agent = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "vigil-agent";
      path = [pkgs.smartmontools];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.vigil-agent}/bin/vigil-agent \
          --server ${cfg.server} \
          ${lib.optionalString (cfg.hostname != null) "--hostname ${cfg.hostname}"} \
          ${cfg.extraFlags}
        '';
        ExecStop = "on-failure";
        StateDirectory = "vigil-agent";
        SyslogIdentifier = "vigil-agent";
        RuntimeDirectory = "vigil-agent";
      };
    };
    users.users = mkIf (cfg.user == "vigil-agent") {
      vigil-agent = {
        name = "vigil-agent";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "vigil-agent") {vigil-agent = {};};
  };
}
