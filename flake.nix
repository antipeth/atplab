{
  description = "Atp's server config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    daeuniverse.url = "github:daeuniverse/flake.nix";
  };
  outputs = inputs: let
    host = "test";
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            deadnix
            rage
            sops
          ];
        };
      };
      flake = {
        nixosConfigurations = {
          "${host}" = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = with inputs; [
              ./machines/${host}
              chaotic.nixosModules.default
              disko.nixosModules.disko
              sops-nix.nixosModules.sops
            ];
            specialArgs = {inherit inputs;};
          };
        };
      };
    };
}
