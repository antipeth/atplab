{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.zeroclaw;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.zeroclaw = {
    enable = mkEnableOption "zeroclaw";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the default port in the firewall";
    };
    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The address for zeroclaw to listen";
    };
    port = mkOption {
      type = types.str;
      default = "3000";
      description = "The port for zeroclaw to listen";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/zeroclaw";
      description = "Directory where Zeroclaw stores its database.";
    };
    user = mkOption {
      type = types.str;
      default = "zeroclaw";
      description = "The user zeroclaw should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "zeroclaw";
      description = "The group zeroclaw should run as.";
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The path to a file containing the zeroclaw environment variables.";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_final: prev: {
        zeroclaw = prev.callPackage ../../pkgs/zeroclaw/default.nix {};
      })
    ];

    systemd.services.zeroclaw = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "zeroclaw";
      serviceConfig = {
        EnvironmentFile =
          lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.zeroclaw}/bin/zeroclaw daemon --host ${cfg.host} -p ${cfg.port}";
        ExecStop = "on-failure";
        StateDirectory = "zeroclaw";
        SyslogIdentifier = "zeroclaw";
        RuntimeDirectory = "zeroclaw";
        WorkingDirectory = "/var/lib/zeroclaw";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall ["${cfg.port}"];

    users.users = mkIf (cfg.user == "zeroclaw") {
      zeroclaw = {
        name = "zeroclaw";
        group = cfg.group;
        isSystemUser = true;
        useDefaultShell = true;
        home = cfg.dataDir;
      };
    };
    users.groups = mkIf (cfg.group == "zeroclaw") {zeroclaw = {};};
    environment.systemPackages = [pkgs.zeroclaw];
  };
}
