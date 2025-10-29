_: {
  virtualisation.oci-containers.containers."convertx" = {
    pull = "newer";
    image = "ghcr.io/c4illin/convertx";
    volumes = [
      "convertx:/app/data:rw"
    ];
    ports = [
      "127.0.0.1:3000:3000"
    ];
  };
}
