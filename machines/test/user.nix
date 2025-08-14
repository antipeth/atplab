_: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        password = "12345";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS0R8+fGFR/fH/tFwc8OWu/f0f9s2osX3uQ07NehZsT"
        ];
      };
    };
  };
}
