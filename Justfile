# use nushell for shell commands
set shell := ["bash", "-c"]

# Set hostname environment
hostname := `hostname`

deploy input:
  # Perform remote deploy action
  sed -i "/^\s*hostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"{{input}}\"/" ./flake.nix ; git add . ; nixos-rebuild switch --flake .#{{input}} --target-host root@{{input}} -v

en input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i

ea:
  ls sops/eval/*/*.nix | xargs -n 1 sops -e -i

de input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i | echo "no commit after decrypt until you encrypt or update again"

da:
  ls sops/eval/*/*.nix | xargs -n 1 sops -d -i | echo "no commit after decrypt until you encrypt or update again"

format:
  # Use alejandra and deadnix to format code
  deadnix -e
  alejandra .
