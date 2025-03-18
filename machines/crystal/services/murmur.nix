{
  services.murmur = {
    enable = true;
    port = 64738;
    password = import ../../../sops/eval/crystal/murmur-password.nix;
    users = import ../../../sops/eval/crystal/murmur-users.nix;
  };
}
