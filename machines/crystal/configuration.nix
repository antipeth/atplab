{ inputs, pkgs, ... }:
{
  imports = [
    ./network.nix
    ./user.nix

    ../../modules/services/dns.nix
    ../../modules/services/fail2ban.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/system/base.nix
    ../../modules/system/environment.nix
    ../../modules/system/minimalise.nix
    ../../modules/system/nix.nix

    ./services/headscale.nix
    ./services/murmur.nix
    ./services/nginx.nix
  ];
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
  swapDevices = [
    {
      device = "/swapfile";
      size = 1076;
    }
  ];

  # Enable networking
  networking = {
    hostName = "crystal";
  };

  clan.core.networking.targetHost = "root@crystal";
}
