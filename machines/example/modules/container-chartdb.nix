_: {
  virtualisation.oci-containers.containers."chartdb" = {
    pull = "newer";
    image = "ghcr.io/chartdb/chartdb:latest";
    ports = [
      "127.0.0.1:18080:80"
    ];
  };
}
