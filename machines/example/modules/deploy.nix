{pkgs, ...}: {
  programs.ssh.startAgent = true;
  users.users = {
    deploy = {
      homeMode = "755";
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "nixbuild"
        "wheel"
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sk" ''
            set -euo pipefail

            KEY_DIR="$HOME/.ssh/keys"

            usage() {
                cat <<EOF
      Usage:
        sk -a <vps-name>    Add key to ssh-agent
        sk -r <vps-name>    Remove key from ssh-agent
        sk -l               List keys in ssh-agent
        sk -h               Show this help
      EOF
            }

            ensure_agent() {
                if [ -z "''${SSH_AUTH_SOCK:-}" ]; then
                    echo "❌ ssh-agent is not running or SSH_AUTH_SOCK is not set"
                    exit 1
                fi
            }

            add_key() {
                name="$1"
                key="$KEY_DIR/$name"

                if [ ! -f "$key" ]; then
                    echo "❌ Key not found: $key"
                    exit 1
                fi

                ensure_agent
                echo "🔐 Adding key: $name"
                ssh-add "$key"
            }

            remove_key() {
                name="$1"
                key="$KEY_DIR/$name"

                ensure_agent
                echo "🗑 Removing key: $name"
                ssh-add -d "$key"
            }

            list_keys() {
                ensure_agent
                ssh-add -l
            }

            [ "$#" -eq 0 ] && usage && exit 1

            case "$1" in
                -a) [ "$#" -eq 2 ] || usage; add_key "$2" ;;
                -r) [ "$#" -eq 2 ] || usage; remove_key "$2" ;;
                -l) list_keys ;;
                -h|--help) usage ;;
                *) usage; exit 1 ;;
            esac
    '')
  ];
}
