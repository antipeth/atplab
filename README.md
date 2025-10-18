## what is this

This is a 🧊.

This is my Homelab and Server NixOS configuration — a collection of configurations that power my personal infrastructure.

---

## 🚀 How to use?

### 🧩 prepare

On your admin machine (for me, it’s NixOS), make sure you have the following tools installed:
* 🧃 [**just**](https://github.com/casey/just)
* 🌱 [**direnv**](https://direnv.net/)

---

#### ⚙️Use direnv
I use **direnv** to automatically activate the `devShell` environment defined in the flake, which includes all required packages.

```nix
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    # Format code
    alejandra
    deadnix
	# Replace nixos-rebuild
    nixos-rebuild-ng
	# Encryption tools
    rage
    sops
  ];
};
```

You should install **direnv** using one of the following methods:
* via [Home Manager option](https://mynixos.com/home-manager/options/programs.direnv)
* via [NixOS option](https://mynixos.com/nixpkgs/options/programs.direnv)

Then, add the shell hook as described in [the official direnv documentation](https://direnv.net/docs/hook.html).

After installation, go to your project’s root directory and run:

```bash
direnv allow
```

This allows direnv to automatically activate the `devShell` defined in your `flake.nix`. 🌀

---

#### 🔐 Prepare for SOPS

You should first have a basic understanding of how [**direnv**](https://direnv.net/) and [**just**](https://github.com/casey/just) work.

You **must carefully read all three guides** 📚:
— [sops-nix (official repo)](https://github.com/Mic92/sops-nix)
- [sops-nix Quick Start Guide](https://blog.0pt.icu/posts/nixos-sops-nix-quick-start-guide/)
- [Using SOPS to Encrypt Nix Values](https://blog.0pt.icu/posts/nixos-using-sops-to-encrypt-nix-values/)

Then, edit your `.sops.yaml` file located in the project root directory.

Since we’re using **sops** for encryption, you should be familiar with its basic usage.

If you haven’t generated an **age** key yet, you can create one with:

```bash
just keygen
```

---

### Use sops to encrypt.

To prevent committing sensitive values in plaintext, follow the steps below 👇

---

#### Using SOPS to Encrypt Nix Values
##### 1. Create directories

```
mkdir machines/<machine-name>/values
```

---

##### 2. Create a value file

Create a file at
`machines/<machine-name>/values/<value-name>.nix`

Its content can be a string, number, etc.

**Example:**
[sops/eval/homelab/forgejo-ssh-port.nix]
```nix
42
```

Then, import it in your machine configuration like this:

[machines/homelab/modules/forgejo.nix]
```nix
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

---

##### 3. Encrypt the files

```bash
just en <machine-name>
```

This command encrypts all `.nix` files in `machines/<machine-name>/values` using **age**.

---

##### 4. Deploy your machine

```bash
just deploy <machine-name>
```

During deployment:

* All `.nix` files in `machines/<machine-name>/values` are **temporarily decrypted** before `nixos-rebuild switch`.
* After rebuilding, they are **re-encrypted automatically**.

This ensures your `.nix` files always remain encrypted — safe to commit and push to Git. 🔐

---

##### 🚨 Post-Deployment Notes

1. ✅ Make sure all `<value>.nix` files are encrypted **before committing** to Git.
2. 🧰 If you need to edit a value file:

```bash
just de <machine-name`.
```

This decrypts all `.nix` files in `machines/<machine-name>/values`.
After editing, re-encrypt them with:

```bash
just en <machine-name>
```

---

#### 🔑 Using sops-nix to encrypt file
##### 1. Create directories

```bash
mkdir machines/<machine-name>/secrets
```

---

##### 2. Use sops encrypt secret files

After configuring `.sops.yaml`, you can simply add a new secret like this:
```bash
just as machines/<machine-name>/secrets/<secret-name>
```

Alternatively, since both the Nix values and secrets are encrypted using **sops**, it’s also valid to perform encryption and decryption operations directly on all files under the `machines/<machine-name>/secrets` directory. Just like this:

```bash
vim machines/<machine-name>/secrets/<secret-name> # Create a plaintext file.
just es <machine-name> # Encrypt all files under machines/<machine-name>/secrets
just ds <machine-name> # Decrypt all files under machines/<machine-name>/secrets
```

---

##### 🧩 Use secret file

In your configuration, reference the secret like this:

```nix
{config, ...}: {
  sops.secrets.<your-want-secret-name> = {
    mode = "0400";
    owner = "wakapi";
    group = "wakapi";
    format = "binary";
    sopsFile = path/to/secrets/<secret-name>;
  };
  services.wakapi = {
    # ...
    passwordSaltFile = config.sops.secrets.<your-want-secret-name>.path;
  };
}
```

> 💡 Note: `<secret-name>` and `<your-want-secret-name>` can be different.

---

## Acknowledgements

Config:
- <https://gitlab.com/Zaney/zaneyos>
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
