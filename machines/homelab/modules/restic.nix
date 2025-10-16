{config, ...}: {
  #   sops.secrets.homelab-restic-remote1-password = {
  #     mode = "0755";
  #     format = "binary";
  #     sopsFile = ../secrets/restic-remote1-password;
  #   };
  #   sops.secrets.homelab-restic-remote1-env = {
  #     mode = "0755";
  #     format = "binary";
  #     sopsFile = ../secrets/restic-remote1-env;
  #   };
  #   sops.secrets.homelab-restic-remote1-repo = {
  #     mode = "0755";
  #     format = "binary";
  #     sopsFile = ../secrets/restic-remote1-repo;
  #   };
  #   services.restic = {
  #     backups = {
  #       remote1 = {
  #         initialize = false;
  #         passwordFile = config.sops.secrets.homelab-restic-remote1-password.path;
  #         environmentFile = config.sops.secrets.homelab-restic-remote1-env.path;
  #         paths = [
  #           "/var/lib/forgejo"
  #           "/var/lib/homebox"
  #           "/var/lib/openlist"
  #           "/var/lib/postgresql"
  #           "/var/lib/wakapi"
  #         ];
  #         repositoryFile = config.sops.secrets.homelab-restic-remote1-repo.path;
  #         timerConfig = {
  #           OnCalendar = "21:10:00";
  #           Persistent = true;
  #         };
  #       };
  #     };
  #   };
}
