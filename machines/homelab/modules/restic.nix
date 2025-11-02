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
    ];
  in
    builtins.listToAttrs (map (n: {
        name = "homelab-${n}";
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
        passwordFile = config.sops.secrets.homelab-restic-passwd.path;
        paths = [
          "/var/lib/forgejo"
          "/var/lib/grafana"
          "/var/lib/homebox"
          "/var/lib/immich"
          "/var/lib/openlist"
          "/var/lib/postgresql"
          "/var/lib/private/gotify-server"
        ];
        timerConfig.Persistent = true;
      };

      mkNotify = remote: {
        prepare = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=0"
        '';
        cleanup = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=${grt}" \
            -F "title=${hostname} restic ${remote} logs" \
            -F "message=$(journalctl -u restic-backups-${remote}.service --since '10 minute ago' -o cat) | over." \
            -F "priority=0"
        '';
      };

      remotes = {
        remote1 = {
          repositoryFile = config.sops.secrets.homelab-restic-remote1-repo.path;
          environmentFile = config.sops.secrets.homelab-restic-remote1-env.path;
          timerConfig.OnCalendar = "22:26:00";
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
