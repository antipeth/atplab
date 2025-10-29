_: {
  virtualisation.oci-containers.containers."opengist" = {
    pull = "newer";
    image = "ghcr.io/thomiceli/opengist:latest";
    environment = {
      "OG_SSH_GIT_ENABLED" = "false";
      "OG_EXTERNAL_URL" = "https://example.com";
    };
    ports = [
      "127.0.0.1:6157:6157"
    ];
    volumes = [
      "opengist:/opengist"
    ];
  };
}
