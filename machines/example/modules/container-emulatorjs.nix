_: {
  virtualisation.oci-containers.containers."emulatorjs" = {
    image = "ghcr.io/linuxserver/emulatorjs:latest";
    volumes = [
      "emulatorjs:/data"
    ];

    ports = [
      "127.0.0.1:13000:3000"
    ];
  };
}
