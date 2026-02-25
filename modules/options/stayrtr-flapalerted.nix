{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.stayrtr-flapalerted;

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    optional
    concatStringsSep
    ;
in {
  options.services.stayrtr-flapalerted = {
    enable = mkEnableOption "StayRTR (with flapalerted-style module)";

    user = mkOption {
      type = types.str;
      default = "stayrtr";
    };

    group = mkOption {
      type = types.str;
      default = "stayrtr";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/stayrtr";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    birdConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra BIRD configuration snippet injected into services.dn42.extraBirdConfig.
        This is typically used to add BGP sessions or filters required by stayrtr-flapalerted.
      '';
    };

    settings = {
      # ── Core / Network ───────────────────────────────────────
      bind = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      maxconn = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      enableNodelay = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      protocol = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      # ── RPKI source ──────────────────────────────────────────
      cache = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      mime = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      useragent = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      # ── Validation behavior ──────────────────────────────────
      checktime = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      etag = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      lastModified = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      notifications = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      disableBgpsec = mkOption {
        type = types.bool;
        default = false;
      };

      enforceVersion = mkOption {
        type = types.bool;
        default = false;
      };

      # ── Timers ───────────────────────────────────────────────
      refresh = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      rtrRefresh = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      rtrRetry = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      rtrExpire = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      # ── HTTP / Metrics ───────────────────────────────────────
      exportPath = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      metricsAddr = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      metricsPath = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      updateEndpoint = mkOption {
        type = types.bool;
        default = false;
      };
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable (
    let
      s = cfg.settings;

      args =
        []
        ++ optional (s.bind != null) "-bind=${s.bind}"
        ++ optional (s.cache != null) "-cache=${s.cache}"
        ++ optional (s.maxconn != null) "-maxconn=${toString s.maxconn}"
        ++ optional (s.protocol != null) "-protocol=${toString s.protocol}"
        ++ optional (s.mime != null) "-mime=${s.mime}"
        ++ optional (s.useragent != null) "-useragent=${s.useragent}"
        # nullOr bool → 显式 true/false
        ++ optional (s.checktime != null)
        "-checktime=${
          if s.checktime
          then "true"
          else "false"
        }"
        ++ optional (s.etag != null)
        "-etag=${
          if s.etag
          then "true"
          else "false"
        }"
        ++ optional (s.lastModified != null)
        "-last.modified=${
          if s.lastModified
          then "true"
          else "false"
        }"
        ++ optional (s.notifications != null)
        "-notifications=${
          if s.notifications
          then "true"
          else "false"
        }"
        ++ optional (s.enableNodelay != null)
        "-enable.nodelay=${
          if s.enableNodelay
          then "true"
          else "false"
        }"
        # plain bool
        ++ optional s.disableBgpsec "-disable.bgpsec"
        ++ optional s.enforceVersion "-enforce.version"
        ++ optional s.updateEndpoint "-update.endpoint"
        # timers
        ++ optional (s.refresh != null) "-refresh=${toString s.refresh}"
        ++ optional (s.rtrRefresh != null) "-rtr.refresh=${toString s.rtrRefresh}"
        ++ optional (s.rtrRetry != null) "-rtr.retry=${toString s.rtrRetry}"
        ++ optional (s.rtrExpire != null) "-rtr.expire=${toString s.rtrExpire}"
        # http / metrics
        ++ optional (s.exportPath != null) "-export.path=${s.exportPath}"
        ++ optional (s.metricsAddr != null) "-metrics.addr=${s.metricsAddr}"
        ++ optional (s.metricsPath != null) "-metrics.path=${s.metricsPath}"
        ++ cfg.extraFlags;
    in {
      systemd.services.stayrtr-flapalerted = {
        description = "StayRTR RPKI RTR server";
        wantedBy = ["multi-user.target"];
        before = ["bird.service"];
        after = ["network.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.stayrtr}/bin/stayrtr ${concatStringsSep " " args}";

          EnvironmentFile =
            mkIf (cfg.environmentFile != null) cfg.environmentFile;

          User = cfg.user;
          Group = cfg.group;

          StateDirectory = "stayrtr";
          WorkingDirectory = cfg.dataDir;

          Restart = "on-failure";
          SyslogIdentifier = "stayrtr";
        };
      };

      services.dn42.extraBirdConfig = lib.mkMerge [
        (mkIf (cfg.birdConfig != "") ''
          # --- stayrtr-flapalerted ---
          ${cfg.birdConfig}
        '')
      ];

      users.users = mkIf (cfg.user == "stayrtr") {
        stayrtr = {
          isSystemUser = true;
          group = cfg.group;
        };
      };

      users.groups = mkIf (cfg.group == "stayrtr") {
        stayrtr = {};
      };
    }
  );
}
