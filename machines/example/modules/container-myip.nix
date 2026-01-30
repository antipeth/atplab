_: {
  virtualisation.oci-containers.containers."myip" = {
    pull = "newer";
    image = "ghcr.io/jason5ng32/myip:latest";
    ports = [
      "127.0.0.1:18966:18966"
    ];
  };
}
