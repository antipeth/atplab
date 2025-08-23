{
  # swapDevices = [
  #   {
  #     label = "swapfile";
  #     discardPolicy = "both";
  #   }
  # ];
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-path/virtio-pci-0000:04:00.0";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 0;
            };
            ESP = {
              size = "512M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              label = "swapfile";
              size = "8G";
              priority = 2;
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
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
      ex1 = {
        name = "ex1";
        device = "/dev/disk/by-path/virtio-pci-0000:08:00.0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/ex1";
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
    };
  };
}
