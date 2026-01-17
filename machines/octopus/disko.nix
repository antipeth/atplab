_: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              size = "1M";
              type = "EF02";
            };
            esp = {
              priority = 2;
              size = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks-root";
                content = {
                  pool = "zroot";
                  type = "zfs";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        datasets = {
          "root" = {
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
            type = "zfs_fs";
          };
        };
        options = {
          ashift = "12";
          compatibility = "grub2";
        };
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "lz4";
          mountpoint = "none";
          xattr = "sa";
        };
        type = "zpool";
      };
    };
  };
}
