{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_net"
        "virtio-pci"
      ];
      kernelModules = [
        "virtio_net"
        "virtio-pci"
      ];
      network = {
        # see https://mynixos.com/nixpkgs/option/boot.initrd.network.enable
        enable = true;
        ssh = {
          enable = true;
          port = 223;
          hostKeys = ["/etc/secrets/initrd/ssh_hostKey"];
        };
      };
      secrets = lib.mkForce {
        "/etc/secrets/initrd/ssh_hostKey" =
          pkgs.writeText "hostKey"
          (import ./values/host-key.nix);
      };
    };
    kernelParams = ["ip=192.168.1.100::192.168.1.1:255.255.255.0::eth0:none"];
  };

  # uncomment this if you want to be asked for the decryption password on login
  # users.root.shell = "/bin/systemd-tty-ask-password-agent";
}
