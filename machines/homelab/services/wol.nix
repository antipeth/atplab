{pkgs, ...}: {
  networking.interfaces.eth0.wakeOnLan.enable = true;
  security.sudo-rs = {
    enable = true;
    extraConfig = "ha ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/systemctl poweroff";
  };
  users = {
    users = {
      ha = {
        isSystemUser = true;
        group = "ha";
        shell = pkgs.bashInteractive;
        openssh.authorizedKeys.keys = [
          ''
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEj9RaCj7LJURlBvWhckGb7qms+B6I4hubPJNRP/439+
          ''
        ];
      };
    };
    groups = {ha = {};};
  };
}
