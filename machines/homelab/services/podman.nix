_: {
  virtualisation = {
    containers = {
      containersConf.settings = {
        containers.dns_servers = [
          "185.222.222.222"
          "45.11.45.11"
          "9.9.9.9"
          "149.112.112.112"
        ];
      };
      enable = true;
      storage.settings = {
        storage.driver = "zfs";
        storage.graphroot = "/var/lib/containers/storage";
        storage.runroot = "/run/containers/storage";
        storage.options.zfs.fsname = "zroot/root";
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    oci-containers.backend = "podman";
  };
}
