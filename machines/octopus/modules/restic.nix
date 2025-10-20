{config, ...}: let
  secretNames = [
    "restic-passwd"
    "restic-remote1-env"
    "restic-remote1-repo"
    "restic-remote2-rclone"
    "restic-remote2-repo"
  ];
in {
  sops.secrets = builtins.listToAttrs (map (n: {
      name = "octopus-${n}";
      value = {
        mode = "0400";
        format = "binary";
        sopsFile = ../secrets/${n};
      };
    })
    secretNames);
  services.restic = {
    backups = {
      remote1 = {
        initialize = true;
        passwordFile = config.sops.secrets.octopus-restic-passwd.path;
        environmentFile = config.sops.secrets.octopus-restic-remote1-env.path;
        paths = [
          "/var/lib/grafana"
          "/var/lib/komari-server"
          "/var/lib/private/gotify-server"
          "/var/lib/private/uptime-kuma"
          "/var/lib/private/wakapi"
        ];
        repositoryFile = config.sops.secrets.octopus-restic-remote1-repo.path;
        timerConfig = {
          OnCalendar = "21:31:00";
          Persistent = true;
        };
      };
      remote2 = {
        initialize = true;
        passwordFile = config.sops.secrets.octopus-restic-passwd.path;
        rcloneConfigFile = config.sops.secrets.octopus-restic-remote2-rclone.path;
        paths = [
          "/var/lib/grafana"
          "/var/lib/komari-server"
          "/var/lib/private/gotify-server"
          "/var/lib/private/uptime-kuma"
          "/var/lib/private/wakapi"
        ];
        repositoryFile = config.sops.secrets.octopus-restic-remote2-repo.path;
        timerConfig = {
          OnCalendar = "22:46:00";
          Persistent = true;
        };
      };
    };
  };
}
