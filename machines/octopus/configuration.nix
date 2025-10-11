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

      ../../sops/eval/octopus/b8b701cb.nix
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
    hostId = "206f0a9a";
    hostName = "octopus";
  };

  clan.core.networking.targetHost = "root@octopus";
}
