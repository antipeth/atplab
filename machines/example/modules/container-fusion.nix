_: {
  virtualisation.oci-containers.containers."fusion" = {
    image = "ghcr.io/0x2e/fusion:latest";
    environment = {
      PASSWORD = "fusion";
    };
    volumes = [
      "fusion:/data:rw"
    ];
    ports = [
      "127.0.0.1:8081:8080"
    ];
  };
}
