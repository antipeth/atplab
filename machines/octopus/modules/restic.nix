{
  config,
  lib,
  ...
}:
with lib; {
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
          "/var/lib/grafana"
          "/var/lib/headscale"
          "/var/lib/komari-server"
          "/var/lib/openlist"
          "/var/lib/private/gotify-server"
          "/var/lib/private/uptime-kuma"
          "/var/lib/private/wakapi"
        ];
        timerConfig.Persistent = true;
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
          timerConfig.OnCalendar = "01:20:00";
        };
        remote3 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote3-repo.path;
          environmentFile = config.sops.secrets.octopus-restic-remote3-env.path;
          timerConfig.OnCalendar = "01:30:00";
        };
        remote4 = {
          repositoryFile = config.sops.secrets.octopus-restic-remote4-repo.path;
          environmentFile = config.sops.secrets.octopus-restic-remote4-env.path;
          timerConfig.OnCalendar = "01:40:00";
        };
      };
      mkBackup = name: cfg: lib.recursiveUpdate common cfg;
    in
      lib.mapAttrs mkBackup remotes;
  };
}
