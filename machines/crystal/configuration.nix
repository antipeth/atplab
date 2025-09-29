{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      ./network.nix
      ./user.nix

      ../../modules/services/dns.nix
      ../../modules/services/fail2ban.nix
      ../../modules/services/ntp.nix
      ../../modules/services/ssh.nix
      ../../modules/system/base.nix
      ../../modules/system/environment.nix
      ../../modules/system/minimalise.nix
      ../../modules/system/nix.nix

      ./services/komari-server.nix
      ./services/murmur.nix
      ./services/nginx.nix
      ./services/restic-server.nix

      ../../sops/eval/crystal/JfcXs618Ks.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/options;
  boot = {
    kernelPackages = inputs.chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos-server;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        configurationLimit = 10;
        enable = true;
        device = "nodev";
      };
    };
  };

  # Enable networking
  networking = {
    hostName = "crystal";
  };

  clan.core.networking.targetHost = "root@crystal";
}
