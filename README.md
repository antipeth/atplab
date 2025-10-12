## what is this

This is a 🧊.

This is my homelab and server nixos config, managed by [clan](https://clan.lol).

## How to use?

### prepare

In your admin machines(For me is nixos), you need install:

- just
- sops
- direnv

Also, you need to read [the documentation for clan](https://docs.clan.lol) carefully.

### Use sops in local.

To avoid the critical value commit, I use this method below the few steps.
#### 0. prepare for sops

You need to read [nix-sops](https://github.com/Mic92/sops-nix) carefully, and edit the `.sops.yaml` in the project root dir.

Because the method use sops to encrypt, so you should know how to use sops simply.

#### 1. mkdir folders

mkdir a folder `sops/eval/<machine-name>`.

#### 2. create the value file

create a `sops/eval/<machine-name>/<value-name>.nix`, the content of this nix file is a strings or a digital, etc. Then I turn to my machine config and imports the nix file like this example:

[sops/eval/homelab/forgejo-ssh-port.nix]
```sops/eval/homelab/forgejo-ssh-port.nix
42
```

[machines/homelab/services/forgejo.nix]
```machines/homelab/services/forgejo.nix
{ pkgs, config, ... }:
{
  services.forgejo = {
    # ...
    settings = {
      server = {
        # ...
        SSH_PORT = import ../../../sops/eval/homelab/forgejo-ssh-port.nix;
        # ...
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    (import ../../../sops/eval/homelab/forgejo-ssh-port.nix)
  ];
}
```

#### 3. Then use:

```bash
just encrypt <machine-name>
```

It will encrypt all .nix file in `sops/eval/<machine-name>` with age.

#### 4. Update the machines:

```bash
just update <machine-name>
```

It will decrypt all .nix file in `sops/eval/<machine-name>` before the `clan machines update`. Once the `clan machines update` command completed, it will encrypt all .nix file in `sops/eval/<machine-name>` with age again. Stay the .nix file in `sops/eval/<machine-name>` encrypted. So you can safely commit and push to git.

#### 🚨Notice

1. You must make sure that all <value>.nix on all your machines are in the encrypted state before you commit the git

2. If you want to edit the `sops/eval/<machine-name>/<value-name>.nix`, your can run:

```bash
just decrypt <machine-name>
```
It decrypt all .nix file in `sops/eval/<machine-name>`. After you've finished your edits, you need to run followed command to stay your .nix file encrypted.
```
just encrypt <machine-name>
```

## Acknowledgements

Config:
- <https://gitlab.com/Zaney/zaneyos>
- <https://github.com/yonzilch/nix-config>
- <https://github.com/yonzilch/yzlab>
- <https://github.com/ryan4yin/nix-config>
- <https://github.com/xddxdd/nixos-config>
- <https://gitea.c3d2.de/c3d2/nix-config>
- <https://github.com/Mic92/dotfiles>

Project:
- <https://github.com/ryan4yin/nixos-and-flakes-book>
- <https://git.clan.lol/clan/clan-core>
- <https://github.com/Mic92/sops-nix>
- <https://github.com/nix-community/disko>
- <https://github.com/nix-community/nixos-anywhere>
