_: {
  virtualisation.oci-containers.containers."myspeed" = {
    pull = "newer";
    image = "germannewsmaker/myspeed:latest";
    volumes = [
      "myspeed:/myspeed/data:rw"
    ];
    ports = [
      "127.0.0.1:5216:5216"
    ];
  };
}
