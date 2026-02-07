{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.vigil-server;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.vigil-server = {
    enable = mkEnableOption "vigil-server";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the vigil-server port in the firewall";
    };
    port = mkOption {
      type = types.port;
      default = 9080;
      description = "Port Vigil server listens on.";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/vigil-server";
      description = "Directory where Vigil stores its database.";
    };
    user = mkOption {
      type = types.str;
      default = "vigil-server";
      description = "The user vigil-server should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "vigil-server";
      description = "The group vigil-server should run as.";
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Optional environment file passed to systemd.
        The file should contain KEY=value pairs, for example:
          ADMIN_PASS=secret
      '';
    };
    auth = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable authentication for Vigil.";
      };
      adminUser = mkOption {
        type = types.str;
        default = "admin";
        description = "Initial admin username.";
      };
      adminPass = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          Initial admin password.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_final: prev: {
        vigil-server = prev.callPackage ../../pkgs/vigil-server/default.nix {};
      })
    ];
    systemd.services.vigil-server = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "vigil-server";
      serviceConfig = {
        Type = "simple";
        Environment = [
          "PORT=${toString cfg.port}"
          "DB_PATH=${cfg.dataDir}/vigil.db"
          "AUTH_ENABLED=${
            if cfg.auth.enable
            then "true"
            else "false"
          }"
          "ADMIN_USER=${cfg.auth.adminUser}"
          "ADMIN_PASS=${cfg.auth.adminPass}"
        ];
        EnvironmentFile =
          mkIf (cfg.environmentFile != null)
          cfg.environmentFile;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''${pkgs.vigil-server}/bin/vigil-server'';
        ExecStop = ''on-failure'';
        WorkingDirectory = "${pkgs.vigil-server}";
        StateDirectory = "vigil-server";
        SyslogIdentifier = "vigil-server";
        RuntimeDirectory = "vigil-server";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    users.users = mkIf (cfg.user == "vigil-server") {
      vigil-server = {
        name = "vigil-server";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "vigil-server") {vigil-server = {};};
  };
}
