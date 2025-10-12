_: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = /run/secret;
        openssh.authorizedKeys.keys = [
          ''
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0ZU4OoffaRXms6vQuRdi1CINE3jT3dFUHPD9HBpakH
          ''
        ];
      };
    };
  };
}
