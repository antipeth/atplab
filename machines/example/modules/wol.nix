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
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0ZU4OoffaRXms6vQuRdi1CINE3jT3dFUHPD9HBpakH
          ''
        ];
      };
    };
    groups = {ha = {};};
  };
}
