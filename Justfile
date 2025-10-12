# use nushell for shell commands
set shell := ["bash", "-c"]

# Set hostname environment
hostname := `hostname`

anywhere input:
  # Perform nixos-anywhere install (generate-hardware-config)
  ls machines/{{input}}/values/* | xargs -n 1 sops decrypt -i ; sed -i "/^\s*hostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"{{input}}\"/" ./flake.nix ; git add . ; nix run github:nix-community/nixos-anywhere -- --flake .#{{input}} --target-host root@{{input}} ; ls machines/{{input}}/values/* | xargs -n 1 sops encrypt -i

anywhere-gh input:
  # Perform nixos-anywhere install (generate-hardware-config)
  ls machines/{{input}}/values/* | xargs -n 1 sops decrypt -i ; sed -i "/^\s*hostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"{{input}}\"/" ./flake.nix ; git add . ; nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./machines/{{input}}/hardware.nix --flake .#{{input}} --target-host root@{{input}} ; ls machines/{{input}}/values/* | xargs -n 1 sops encrypt -i

anywhere-lb input:
  # Berform nixos-anywhere install (local builder)
  ls machines/{{input}}/values/* | xargs -n 1 sops decrypt -i ; sed -i "/^\s*hostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"{{input}}\"/" ./flake.nix ; git add . ; nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./machines/{{input}}/hardware.nix --flake .#{{input}} --target-host root@{{input}} --build-on local --show-trace ; ls machines/{{input}}/values/* | xargs -n 1 sops encrypt -i

deploy input:
  # Perform remote deploy action
  ls machines/{{input}}/values/* | xargs -n 1 sops decrypt -i ; sed -i "/^\s*hostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"{{input}}\"/" ./flake.nix ; git add . ; nixos-rebuild switch --flake .#{{input}} --target-host root@{{input}} -v ; ls machines/{{input}}/values/* | xargs -n 1 sops encrypt -i

da:
  # Decrypt all
  ls modules/private/**/* | xargs -n 1 sops decrypt -i

de input:
  # Decrypt
  ls machines/{{input}}/values/* | xargs -n 1 sops decrypt -i

ds input:
  # Decrypt
  ls machines/{{input}}/secrets/* | xargs -n 1 sops decrypt -i

ea:
  # encrypt all
  ls modules/private/**/* | xargs -n 1 sops encrypt -i

en input:
  # Encrypt
  ls machines/{{input}}/values/* | xargs -n 1 sops encrypt -i

es input:
  # Encrypt
  ls machines/{{input}}/secrets/* | xargs -n 1 sops encrypt -i

as input:
  # Add secret
  sops {{input}}

format:
  # Use alejandra and deadnix to format code
  deadnix -e
  alejandra .
