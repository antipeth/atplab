{
  description = "<Put your description here>";

  inputs.clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
  inputs.nixpkgs.follows = "clan-core/nixpkgs";

  inputs.proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

  inputs.microvm.url = "github:astro/microvm.nix";
  inputs.microvm.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      clan-core,
      nixpkgs,
      proxmox-nixos,
      microvm,
      ...
    }:
    let
      # Usage see: https://docs.clan.lol
      clan = clan-core.lib.buildClan {
        inherit self;
        # Ensure this is unique among all clans you want to use.
        meta.name = "atp";

        machines = {
          freezer = {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              proxmox-nixos.nixosModules.proxmox-ve
              ({
                nixpkgs.overlays = [
                  proxmox-nixos.overlays.x86_64-linux
                ];

                # The rest of your configuration...
              })
            ];
          };

        };
      };
    in
    {
      # All machines managed by Clan.
      inherit (clan) nixosConfigurations clanInternals;
      # Add the Clan cli tool to the dev shell.
      # Use "nix develop" to enter the dev shell.
      devShells =
        clan-core.inputs.nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
          ]
          (system: {
            default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
              packages = [ clan-core.packages.${system}.clan-cli ];
            };
          });
    };
}
