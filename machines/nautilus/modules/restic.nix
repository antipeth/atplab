{
  config,
  hostname,
  lib,
  pkgs,
  ...
}:
with lib; let
  grt = import ../values/gotify-restic-token.nix;
in {
  sops.secrets = let
    secretNames = [
      "restic-passwd"
      "restic-remote1-env"
      "restic-remote1-repo"
      "restic-remote2-rclone"
      "restic-remote2-repo"
      "restic-remote3-env"
      "restic-remote3-repo"
      "restic-remote4-env"
      "restic-remote4-repo"
      "restic-remote5-rclone"
      "restic-remote5-repo"
    ];
  in
    builtins.listToAttrs (map (n: {
        name = "nautilus-${n}";
        value = {
          mode = "0400";
          format = "binary";
          sopsFile = ../secrets/${n};
        };
      })
      secretNames);

  services.restic = {
    backups = let
      common = {
        initialize = true;
        passwordFile = config.sops.secrets.nautilus-restic-passwd.path;
        paths = [
          "/var/lib/fail2ban"
          "/var/lib/komari-server"
          "/var/lib/private/gatus"
          "/var/lib/private/gotify-server"
          "/var/lib/private/uptime-kuma"
        ];
        timerConfig.Persistent = true;
        pruneOpts = [
          "--keep-daily 7"
        ];
      };

      mkNotify = remote: {
        prepare = ''
          ${pkgs.curl}/bin/curl "http://${config.services.gotify.environment.GOTIFY_SERVER_LISTENADDR}:${toString config.services.gotify.environment.GOTIFY_SERVER_PORT}/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=0"
        '';
        cleanup = ''
          ${pkgs.curl}/bin/curl "http://${config.services.gotify.environment.GOTIFY_SERVER_LISTENADDR}:${toString config.services.gotify.environment.GOTIFY_SERVER_PORT}/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} logs" \
            -F "message=$(journalctl -u restic-backups-${remote}.service --since '10 minute ago' -o cat) | over." \
            -F "priority=0"
        '';
      };

      remotes = {
        remote1 = {
          repositoryFile = config.sops.secrets.nautilus-restic-remote1-repo.path;
          environmentFile = config.sops.secrets.nautilus-restic-remote1-env.path;
          timerConfig.OnCalendar = "02:00:00";
        };
        remote2 = {
          repositoryFile = config.sops.secrets.nautilus-restic-remote2-repo.path;
          rcloneConfigFile = config.sops.secrets.nautilus-restic-remote2-rclone.path;
          timerConfig.OnCalendar = "02:05:00";
        };
        remote3 = {
          repositoryFile = config.sops.secrets.nautilus-restic-remote3-repo.path;
          environmentFile = config.sops.secrets.nautilus-restic-remote3-env.path;
          timerConfig.OnCalendar = "02:10:00";
        };
        remote4 = {
          repositoryFile = config.sops.secrets.nautilus-restic-remote4-repo.path;
          environmentFile = config.sops.secrets.nautilus-restic-remote4-env.path;
          timerConfig.OnCalendar = "02:15:00";
        };
        remote5 = {
          repositoryFile = config.sops.secrets.nautilus-restic-remote5-repo.path;
          rcloneConfigFile = config.sops.secrets.nautilus-restic-remote5-rclone.path;
          timerConfig.OnCalendar = "02:20:00";
        };
      };

      mkBackup = name: cfg:
        recursiveUpdate common (
          cfg
          // {
            backupPrepareCommand = (mkNotify name).prepare;
            backupCleanupCommand = (mkNotify name).cleanup;
          }
        );
    in
      mapAttrs mkBackup remotes;
  };
}
