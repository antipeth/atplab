{
  inputs,
  lib,
  ...
}:
with lib; {
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      connect-timeout = 5;
      gc-keep-outputs = false;
      gc-keep-derivations = false;
      keep-going = true;
      log-lines = 25;
      nix-path = mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      substituters = [
        # "https://cache.garnix.io"
        "https://cache.nixos.org"
        # "https://chaotic-nyx.cachix.org"
        "https://nix-community.cachix.org"
        # "https://cache.saumon.network/proxmox-nixos"
      ];
      trusted-public-keys = [
        # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys="
      ];
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };
}
