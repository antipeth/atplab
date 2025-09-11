{inputs, ...}: {
  imports = [
    ./network.nix
    ./user.nix

    ../../modules/services/dns.nix
    ../../modules/services/fail2ban.nix
    ../../modules/services/ssh.nix
    ../../modules/system/base.nix
    ../../modules/system/environment.nix
    ../../modules/system/minimalise.nix
    ../../modules/system/nix.nix

    ../../sops/eval/auction/YscKhAR1Lv.nix
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

  # Enable networking
  networking = {
    hostName = "auction";
  };

  clan.core.networking.targetHost = "root@auction";
}
