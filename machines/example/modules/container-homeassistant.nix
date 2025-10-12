_: {
  virtualisation.oci-containers.containers.ha = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = ["home-assistant:/config"];

    extraOptions = [
      # Use the host network namespace for all sockets
      "--network=host"
      # Pass devices into the container, so Home Assistant can discover and make use of them
      # "--device=/dev/ttyACM0:/dev/ttyACM0"
    ];

    environment.TZ = "Asia/Singapore";
  };
}
