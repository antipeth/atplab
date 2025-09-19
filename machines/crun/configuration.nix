{inputs, ...}: {
  imports = [
    ../../sops/eval/crun/network.nix
    ../../sops/eval/crun/user.nix
    ../../sops/eval/crun/JikiGE.nix

    ../../modules/services/dns.nix
    ../../modules/services/fail2ban.nix
    ../../modules/services/ntp.nix
    ../../modules/services/ssh.nix
    ../../modules/system/base.nix
    ../../modules/system/environment.nix
    ../../modules/system/minimalise.nix
    ../../modules/system/nix.nix
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
    hostName = "crun";
  };

  clan.core.networking.targetHost = "root@crun";
}
