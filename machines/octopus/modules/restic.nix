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
        name = "octopus-${n}";
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
        passwordFile = config.sops.secrets.octopus-restic-passwd.path;
        paths = [
          "/var/lib/akkoma"
          "/var/lib/fail2ban"
          "/var/lib/grafana"
          "/var/lib/kanidm"
          "/var/lib/kavita"
          "/var/lib/openlist"
          "/var/lib/postgresql"
          "/var/lib/radicale"
          "/var/lib/private/actual"
          "/var/lib/private/readeck"
          "/var/lib/private/wakapi"
        ];
        timerConfig.Persistent = true;
        pruneOpts = [
          "--keep-daily 7"
        ];
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
          repositoryFile = config.sops.secrets.octopus-restic-remote1-repo.path;
          environmentFile = config.sops.secrets.octopus-restic-remote1-env.path;
          timerConfig.OnCalendar = "01:00:00";
        };
        remote2 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote2-repo.path;
          rcloneConfigFile = config.sops.secrets.octopus-restic-remote2-rclone.path;
          timerConfig.OnCalendar = "01:10:00";
        };
        remote3 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote3-repo.path;
          environmentFile = config.sops.secrets.octopus-restic-remote3-env.path;
          timerConfig.OnCalendar = "01:20:00";
        };
        remote4 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote4-repo.path;
          environmentFile = config.sops.secrets.octopus-restic-remote4-env.path;
          timerConfig.OnCalendar = "01:30:00";
        };
        remote5 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote5-repo.path;
          rcloneConfigFile = config.sops.secrets.octopus-restic-remote5-rclone.path;
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
