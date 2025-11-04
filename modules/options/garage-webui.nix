{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.garage-webui;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.garage-webui = {
    enable = mkEnableOption "garage-webui";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the default port in the firewall";
    };
    port = mkOption {
      type = types.port;
      default = 3909;
      description = "The port for garage-webui to listen";
    };
    user = mkOption {
      type = types.str;
      default = "garage-webui";
      description = "The user garage-webui should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "garage-webui";
      description = "The group garage-webui should run as.";
    };
    password = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Enable authentication by setting the `AUTH_USER_PASS` environment variable in the format `username:password_hash`, where `password_hash` is a bcrypt hash of the password.
        Generate the username and password hash using the following command:
        ```bash
        htpasswd -nbBC 10 "YOUR_USERNAME" "YOUR_PASSWORD"
        ```
        > If command 'htpasswd' is not found, install apache2-utils using your package manager.
      '';
    };
    configPath = mkOption {
      type = types.str;
      default = "/etc/garage.toml";
      description = "Path to the Garage config.toml file. Defaults to `/etc/garage.toml`.";
    };
    basePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Base path or prefix for Web UI.";
    };
    apiBaseUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Garage admin API endpoint URL.";
    };
    apiAdminKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Admin API key.";
    };
    s3Region = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "S3 Region.";
    };
    s3EndpointUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "S3 Endpoint url.";
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The path to a file containing the garage-webui environment variables.";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_final: prev: {
        garage-webui = prev.callPackage ../../pkgs/garage-webui/default.nix {};
      })
    ];

    systemd.services.garage-webui = {
      wantedBy = ["default.target"];
      after = ["network.target"];
      description = "Garage Web UI";
      serviceConfig = {
        Environment =
          (lib.optional (cfg.port != null) "PORT=${toString cfg.port}")
          ++ (lib.optional (cfg.password != null) "AUTH_USER_PASS=${cfg.password}")
          ++ (lib.optional (cfg.configPath != null) "CONFIG_PATH=${cfg.configPath}")
          ++ (lib.optional (cfg.basePath != null) "BASE_PATH=${cfg.basePath}")
          ++ (lib.optional (cfg.apiBaseUrl != null) "API_BASE_URL=${cfg.apiBaseUrl}")
          ++ (lib.optional (cfg.apiAdminKey != null) "API_ADMIN_KEY=${cfg.apiAdminKey}")
          ++ (lib.optional (cfg.s3Region != null) "S3_REGION=${cfg.s3Region}")
          ++ (lib.optional (cfg.s3EndpointUrl != null) "S3_ENDPOINT_URL=${cfg.s3EndpointUrl}");
        EnvironmentFile =
          lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.garage-webui}/bin/garage-webui";
        ExecStop = "on-failure";
        StateDirectory = "garage-webui";
        SyslogIdentifier = "garage-webui";
        RuntimeDirectory = "garage-webui";
        WorkingDirectory = "/var/lib/garage-webui";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    users.users = mkIf (cfg.user == "garage-webui") {
      garage-webui = {
        name = "garage-webui";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "garage-webui") {garage-webui = {};};
  };
}
