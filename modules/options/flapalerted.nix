{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.flapalerted;

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
  options.services.flapalerted = {
    enable = mkEnableOption "flapalerted BGP flap detection service";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };

    user = mkOption {
      type = types.str;
      default = "flapalerted";
    };

    group = mkOption {
      type = types.str;
      default = "flapalerted";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/flapalerted";
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
        This is typically used to add BGP sessions or filters required by flapalerted.
      '';
    };

    settings = {
      # ── BGP / core ─────────────────────────────────────────────
      asn = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      bgpListenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      debug = mkOption {
        type = types.bool;
        default = false;
      };

      disableAddPath = mkOption {
        type = types.bool;
        default = false;
      };

      routeChangeCounter = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      expiryRouteChangeCounter = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      overThresholdTarget = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      underThresholdTarget = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      importLimitThousands = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      maxPathHistory = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      routerID = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      # ── HTTP API ───────────────────────────────────────────────
      httpAPIListenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      httpAPIKey = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      httpAPILimit = mkOption {
        type = types.bool;
        default = false;
      };

      # ── HTTP Dashboard / Gage ──────────────────────────────────
      httpGageDisableDynamic = mkOption {
        type = types.bool;
        default = false;
      };

      httpGageMaxValue = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      httpMaxUserDefined = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };

      # ── Webhook ────────────────────────────────────────────────
      webhookUrlStart = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Webhook URLs triggered when a flap event starts.";
      };

      webhookUrlEnd = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Webhook URLs triggered when a flap event ends.";
      };

      webhookTimeout = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Timeout for webhook HTTP requests (e.g. 5s).";
      };

      webhookInstanceName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional instance name sent as webhook header.";
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
        # ── core / BGP
        ++ optional (s.asn != null)
        "-asn=${toString s.asn}"
        ++ optional (s.bgpListenAddress != null)
        "-bgpListenAddress=${s.bgpListenAddress}"
        ++ optional (s.routeChangeCounter != null)
        "-routeChangeCounter=${toString s.routeChangeCounter}"
        ++ optional (s.expiryRouteChangeCounter != null)
        "-expiryRouteChangeCounter=${toString s.expiryRouteChangeCounter}"
        ++ optional (s.overThresholdTarget != null)
        "-overThresholdTarget=${toString s.overThresholdTarget}"
        ++ optional (s.underThresholdTarget != null)
        "-underThresholdTarget=${toString s.underThresholdTarget}"
        ++ optional (s.importLimitThousands != null)
        "-importLimitThousands=${toString s.importLimitThousands}"
        ++ optional (s.maxPathHistory != null)
        "-maxPathHistory=${toString s.maxPathHistory}"
        ++ optional (s.routerID != null)
        "-routerID=${s.routerID}"
        ++ optional s.debug "-debug"
        ++ optional s.disableAddPath "-disableAddPath"
        # ── HTTP API
        ++ optional (s.httpAPIListenAddress != null)
        "-httpAPIListenAddress=${s.httpAPIListenAddress}"
        ++ optional (s.httpAPIKey != null)
        "-httpAPIKey=${s.httpAPIKey}"
        ++ optional s.httpAPILimit "-httpAPILimit"
        # ── HTTP dashboard / Gage
        ++ optional s.httpGageDisableDynamic "-httpGageDisableDynamic"
        ++ optional (s.httpGageMaxValue != null)
        "-httpGageMaxValue=${toString s.httpGageMaxValue}"
        ++ optional (s.httpMaxUserDefined != null)
        "-httpMaxUserDefined=${toString s.httpMaxUserDefined}"
        # ── Webhooks (repeatable)
        ++ map (u: "-webhookUrlStart=${u}") s.webhookUrlStart
        ++ map (u: "-webhookUrlEnd=${u}") s.webhookUrlEnd
        ++ optional (s.webhookTimeout != null)
        "-webhookTimeout=${s.webhookTimeout}"
        ++ optional (s.webhookInstanceName != null)
        "-webhookInstanceName=${s.webhookInstanceName}"
        # ── escape hatch
        ++ cfg.extraFlags;
    in {
      assertions = [
        {
          assertion = cfg.birdConfig == "" || config.services.dn42.enable or false;
          message = "services.flapalerted.birdConfig requires services.dn42.enable = true";
        }
      ];

      nixpkgs.overlays = [
        (_final: prev: {
          flapalerted = prev.callPackage ../../pkgs/flapalerted/default.nix {};
        })
      ];

      systemd.services.flapalerted = {
        description = "flapalerted BGP flap detection service";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          Type = "simple";
          environmentFile =
            mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = "${pkgs.flapalerted}/bin/flapalerted ${concatStringsSep " " args}";

          User = cfg.user;
          Group = cfg.group;

          StateDirectory = "flapalerted";
          WorkingDirectory = cfg.dataDir;

          Restart = "on-failure";
          SyslogIdentifier = "flapalerted";
        };
      };

      services.dn42.extraBirdConfig = lib.mkMerge [
        (mkIf (cfg.birdConfig != "") ''
          # --- flapalerted ---
          ${cfg.birdConfig}
        '')
      ];

      users.users = mkIf (cfg.user == "flapalerted") {
        flapalerted = {
          isSystemUser = true;
          group = cfg.group;
        };
      };

      users.groups = mkIf (cfg.group == "flapalerted") {
        flapalerted = {};
      };
    }
  );
}
