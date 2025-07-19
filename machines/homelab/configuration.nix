{lib, ...}: {
  imports =
    [
      ./user.nix

      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix
      ../../modules/system/zfs.nix

      ../../modules/services/blacklist.nix
      ../../modules/services/dns.nix
      ../../modules/services/fail2ban.nix
      ../../modules/services/ssh.nix
      ../../modules/services/tailscale.nix

      # ./services/alist.nix
      ./services/aria2.nix
      ./services/cockpit.nix
      # ./services/code-server.nix
      ./services/dashy.nix
      ./services/forgejo.nix
      ./services/glances.nix
      ./services/gotify.nix
      # ./services/home-assistant.nix
      ./services/homebox.nix
      ./services/immich.nix
      ./services/iperf3.nix
      ./services/jellyfin.nix
      ./services/kodi.nix
      ./services/nginx.nix
      ./services/podman.nix
      ./services/postgres.nix
      ./services/power-management.nix
      ./services/radicale.nix
      ./services/restic.nix
      ./services/samba.nix
      ./services/syncthing.nix
      ./services/wakapi.nix

      ./services/docker/romm.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/options;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking = {
    hostId = "2aff655b";
    hostName = "homelab";
  };

  clan.core.networking.targetHost = "root@homelab";
}
