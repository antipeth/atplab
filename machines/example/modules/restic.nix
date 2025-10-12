{pkgs, ...}: {
  services.restic = {
    backups = {
      local = {
        initialize = true;
        passwordFile = /run/secret;
        paths = [
          "/var/lib/forgejo"
          "/var/lib/homebox"
          "/var/lib/openlist"
          "/var/lib/postgresql"
          "/var/lib/wakapi"
        ];
        repository = "/backup/restic";
        timerConfig = {
          OnCalendar = "21:00:00";
          Persistent = true;
        };
        backupPrepareCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic local backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=2"
        '';
        backupCleanupCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic local logs" \
            -F "message=$(journalctl -u restic-backups-local.service --since '10 minute ago' -o cat) | over." \
            -F "priority=1"
        '';
      };
      remote1 = {
        initialize = true;
        passwordFile = /run/secret;
        environmentFile = /run/secret;
        paths = [
          "/var/lib/forgejo"
          "/var/lib/homebox"
          "/var/lib/openlist"
          "/var/lib/postgresql"
          "/var/lib/wakapi"
        ];
        repositoryFile = /run/secret;
        timerConfig = {
          OnCalendar = "21:10:00";
          Persistent = true;
        };
        backupPrepareCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic remote1 backup start" \
            -F "message=$(date "+%H:%M:%S")" \
            -F "priority=2"
        '';
        backupCleanupCommand = ''
          ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
            -F "title=restic remote1 logs" \
            -F "message=$(journalctl -u restic-backups-remote1.service --since '10 minute ago' -o cat) | over." \
            -F "priority=1"
        '';
      };
    };
  };
}
