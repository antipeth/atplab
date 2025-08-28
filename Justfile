keygen:
  clan secrets key generate

set input:
  clan secrets set {{input}}

get input:
  clan secrets get {{input}}

list-s:
  clan secrets list

list-m:
  clan machines list

install input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines install {{input}} --target-host {{input}}  --update-hardware-config nixos-facter ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i

deploy input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines update {{input}} ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i

encrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i

decrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i | echo "no commit after decrypt until you encrypt or update again"

format:
  # Use alejandra and deadnix to format code
  deadnix -e
  alejandra .
