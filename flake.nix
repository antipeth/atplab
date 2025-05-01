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

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        self,
        inputs,
        nixpkgs,
        microvm,
        ...
      }:
      {
        systems = [ "x86_64-linux" ];
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
            freezer = {
              nixpkgs.hostPlatform = "x86_64-linux";
              imports = [
                #     proxmox-nixos.nixosModules.proxmox-ve
                #     ({
                #       nixpkgs.overlays = [
                #         proxmox-nixos.overlays.x86_64-linux
                #       ];
                #
                #       # The rest of your configuration...
                #     })
                microvm.nixosModules.host
                {
                  microvm.vms = {
                    vm1 = {
                      pkgs = import nixpkgs { system = "x86_64-linux"; };
                      config = import ./machines/freezer/vms/vm1.nix;
                    };
                  };
                }
              ];
            };
          };
        };
        perSystem =
          {
            inputs',
            pkgs,
            ...
          }:
          {
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
  # let
  #   # Usage see: https://docs.clan.lol
  #   clan = clan-core.lib.buildClan {
  #     inherit self;
  #     # Ensure this is unique among all clans you want to use.
  #     meta.name = "atp";
  #
  #     machines = {
  #       freezer = {
  #         nixpkgs.hostPlatform = "x86_64-linux";
  #         imports = [
  #           #     proxmox-nixos.nixosModules.proxmox-ve
  #           #     ({
  #           #       nixpkgs.overlays = [
  #           #         proxmox-nixos.overlays.x86_64-linux
  #           #       ];
  #           #
  #           #       # The rest of your configuration...
  #           #     })
  #           microvm.nixosModules.host
  #           {
  #             microvm.vms = {
  #               vm1 = {
  #                 pkgs = import nixpkgs { system = "x86_64-linux"; };
  #                 config = import ./machines/freezer/vms/vm1.nix;
  #               };
  #             };
  #           }
  #         ];
  #       };
  #     };
  #   };
  # in
  # {
  #   # All machines managed by Clan.
  #   inherit (clan) nixosConfigurations clanInternals;
  #   # Add the Clan cli tool to the dev shell.
  #   # Use "nix develop" to enter the dev shell.
  #   devShells =
  #     clan-core.inputs.nixpkgs.lib.genAttrs
  #       [
  #         "x86_64-linux"
  #         "aarch64-linux"
  #         "aarch64-darwin"
  #         "x86_64-darwin"
  #       ]
  #       (system: {
  #         default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
  #           packages = [ clan-core.packages.${system}.clan-cli ];
  #         };
  #       });
  # };
}
