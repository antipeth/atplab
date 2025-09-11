{
  description = "<Put your description here>";

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    clan-core = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    };

    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };

    # proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    daeuniverse.url = "github:daeuniverse/flake.nix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
        self,
        inputs,
        nixpkgs,
        microvm,
        ...
      }: {
        systems = ["x86_64-linux"];
        imports = [
          inputs.clan-core.flakeModules.default
        ];
        clan = {
          meta.name = "atp";
          specialArgs = {
            inputs = inputs;
            self = self;
          };
          machines = {
          };
        };
        perSystem = {
          inputs',
          pkgs,
          ...
        }: {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              inputs'.clan-core.packages.clan-cli
              alejandra
              commitlint-rs
              deadnix
              sops
            ];
          };
        };
      }
    );
}
