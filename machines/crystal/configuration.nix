{ pkgs, ... }:
{
  imports = [
    ./network.nix
    ./user.nix

    ../../modules/services/dns.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/system/base.nix
    ../../modules/system/environment.nix
    ../../modules/system/minimalise.nix
    ../../modules/system/nix.nix

    # ./services/traefik.nix
    ./services/headscale.nix
    ./services/netdata.nix
    ./services/nginx.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
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
