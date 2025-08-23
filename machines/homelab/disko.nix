_: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = import ../../sops/eval/homelab/disko-main-device.nix;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 0;
            };
            ESP = {
              size = "1G";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
          acltype = "posixacl";
          atime = "off";
          compression = "lz4";
          mountpoint = "none";
          xattr = "sa";
        };
        options.ashift = "12";

        datasets = {
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            # Used by services.zfs.autoSnapshot options.
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
            };
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "legacy";
            };
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "legacy";
            };
          };
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "legacy";
            };
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/root@blank$' || zfs snapshot zroot/root@blank";
          };
        };
      };
      # tank = {
      #   type = "zpool";
      #   mode = "mirror";
      #   rootFsOptions = {
      #     # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
      #     acltype = "posixacl";
      #     atime = "off";
      #     compression = "lz4";
      #     mountpoint = "none";
      #     xattr = "sa";
      #   };
      #   options.ashift = "12";
      #
      #   datasets = {
      #     share = {
      #       type = "zfs_fs";
      #       mountpoint = "/share";
      #       # Used by services.zfs.autoSnapshot options.
      #       options = {
      #         "com.sun:auto-snapshot" = "true";
      #         mountpoint = "legacy";
      #       };
      #     };
      #     media = {
      #       type = "zfs_fs";
      #       mountpoint = "/media";
      #       options = {
      #         "com.sun:auto-snapshot" = "true";
      #         mountpoint = "legacy";
      #       };
      #     };
      #     backup = {
      #       type = "zfs_fs";
      #       mountpoint = "/backup";
      #       options = {
      #         "com.sun:auto-snapshot" = "true";
      #         mountpoint = "legacy";
      #       };
      #     };
      #   };
      # };
    };
  };
}
