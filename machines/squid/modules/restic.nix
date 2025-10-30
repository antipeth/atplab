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
    ];
  in
    builtins.listToAttrs (map (n: {
        name = "squid-${n}";
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
        passwordFile = config.sops.secrets.squid-restic-passwd.path;
        paths = [
          "/var/lib/containers/storage/volumes/atomic-storage"
          "/var/lib/containers/storage/volumes/fusion"
          "/var/lib/containers/storage/volumes/glance"
          "/var/lib/containers/storage/volumes/goatcounter"
          "/var/lib/containers/storage/volumes/opengist"
          "/var/lib/containers/storage/volumes/postgres"
          "/var/lib/containers/storage/volumes/readeck"
        ];
        timerConfig.Persistent = true;
      };

      mkNotify = remote: {
        prepare = ''
          ${pkgs.curl}/bin/curl "https://gotify.0pt.dpdns.org/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=0"
        '';
        cleanup = ''
          ${pkgs.curl}/bin/curl "https://gotify.0pt.dpdns.org/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} logs" \
            -F "message=$(journalctl -u restic-backups-${remote}.service --since '10 minute ago' -o cat) | over." \
            -F "priority=0"
        '';
      };

      remotes = {
        remote1 = {
          repositoryFile = config.sops.secrets.squid-restic-remote1-repo.path;
          environmentFile = config.sops.secrets.squid-restic-remote1-env.path;
          timerConfig.OnCalendar = "01:00:00";
        };
        remote2 = {
          repositoryFile = config.sops.secrets.squid-restic-remote2-repo.path;
          rcloneConfigFile = config.sops.secrets.squid-restic-remote2-rclone.path;
          timerConfig.OnCalendar = "01:20:00";
        };
        remote3 = {
          repositoryFile = config.sops.secrets.squid-restic-remote3-repo.path;
          environmentFile = config.sops.secrets.squid-restic-remote3-env.path;
          timerConfig.OnCalendar = "01:30:00";
        };
        remote4 = {
          repositoryFile = config.sops.secrets.squid-restic-remote4-repo.path;
          environmentFile = config.sops.secrets.squid-restic-remote4-env.path;
          timerConfig.OnCalendar = "01:40:00";
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
