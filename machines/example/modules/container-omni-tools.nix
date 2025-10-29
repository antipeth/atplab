_: {
  virtualisation.oci-containers.containers."omni-tools" = {
    pull = "newer";
    image = "iib0011/omni-tools:latest";
    ports = [
      "127.0.0.1:18001:80"
    ];
  };
}
